// 共通の書き出し部品: 描いたコマを1枚ずつ時刻付きでエンコードし、MP4（音つきも可）にまとめる。
// 元にした実装: Vlog-Studio.html（なめらか書き出し）と bokasi.html（ynFrameExport）。
// コマの用意（動画の移動・描画・バックグラウンド中の待機）と音の合成は、各アプリ側で行う。
//
// 使い方:
//   import {createMp4Writer} from './lib/export-mp4.js';
//   const w=await createMp4Writer({width:1080,height:1920,fps:30,bitrate:8e6,audio:true});
//   if(!w.ok){ /* w.reason で実時間の録画などに切り替える */ }
//   for(let i=0;i<frameCount;i++){ draw(i/30); await w.addFrame(canvas,i); }
//   if(w.audioCodec) await w.addAudio(audioBuffer);   // 48kHz の AudioBuffer（OfflineAudioContext の結果など）
//   const {blob,stats}=await w.finish();

const MUXER_URL='https://esm.sh/mp4-muxer@5.1.3';
const AAC_RATES=[96000,88200,64000,48000,44100,32000,24000,22050,16000,12000,11025,8000];

// H.264 のレベルをコマの大きさから決める（1080p までは 4.0、それより大きければ 5.0 / 5.1）。
const avcLevel=(width,height)=>{
  const mbs=Math.ceil(width/16)*Math.ceil(height/16);
  return mbs<=8192?'28':mbs<=22080?'32':'33';
};

// 試す順番: H.264 High → Main → Baseline、どれも無理なら VP9。音は AAC、無理なら Opus。
const videoCandidates=(width,height,fps,bitrate)=>{
  const lv=avcLevel(width,height);
  return [[`avc1.6400${lv}`,'avc'],[`avc1.4d00${lv}`,'avc'],[`avc1.4200${lv}`,'avc'],['vp09.00.40.08','vp9']]
    .map(([codec,mux])=>({mux,config:{codec,width,height,bitrate,framerate:fps,...(mux==='avc'?{avc:{format:'avc'}}:{})}}));
};
const audioCandidates=(sampleRate,channels,bitrate)=>
  [['mp4a.40.2','aac'],['opus','opus']].map(([codec,mux])=>({mux,config:{codec,sampleRate,numberOfChannels:channels,bitrate}}));

const firstSupported=async(Encoder,candidates)=>{
  for(const c of candidates){
    if(await Encoder.isConfigSupported(c.config).then(r=>r.supported,()=>false)) return c;
  }
  return null;
};

// エンコーダが返す description が esds（0x03 で始まる）なら、中の AudioSpecificConfig だけを取り出す。
export function aacSpecificConfig(bytes){
  if(!bytes||!bytes.length||bytes[0]!==0x03) return bytes;
  let at=0;
  const read=()=>{const tag=bytes[at++];let size=0;for(let k=0;k<4;k++){const v=bytes[at++];size=(size<<7)|(v&0x7f);if(!(v&0x80))break;}return {tag,size};};
  try{
    if(read().tag!==3) return null;
    at+=2;const flags=bytes[at++];if(flags&0x80)at+=2;if(flags&0x40)at+=1+bytes[at];if(flags&0x20)at+=2;
    if(read().tag!==4) return null;
    at+=13;const s=read();
    if(s.tag!==5||s.size<2||at+s.size>bytes.length) return null;
    return bytes.slice(at,at+s.size);
  }catch{ return null; }
}

// AAC-LC の AudioSpecificConfig（種類2・サンプルレートの番号・チャンネル数）。エンコーダが description を付けないときに使う。
const fallbackAacConfig=(sampleRate,channels)=>{
  const index=AAC_RATES.indexOf(sampleRate);
  return new Uint8Array([(2<<3)|(index>>1),((index&1)<<7)|(channels<<3)]);
};

const errorText=e=>e?.message||e?.name||'不明';
const sleep=ms=>new Promise(r=>setTimeout(r,ms));

// この端末で使える方式を調べる（書き出しはしない）。診断表示用。
export async function probeMp4Support({width=1080,height=1920,fps=30,bitrate=8000000,sampleRate=48000,channels=2}={}){
  const out={videoEncoder:typeof VideoEncoder==='function',videoFrame:typeof VideoFrame==='function',
    audioEncoder:typeof AudioEncoder==='function',audioData:typeof AudioData==='function',videoCodec:null,audioCodec:null};
  if(out.videoEncoder) out.videoCodec=(await firstSupported(VideoEncoder,videoCandidates(width,height,fps,bitrate)))?.config.codec||null;
  if(out.audioEncoder) out.audioCodec=(await firstSupported(AudioEncoder,audioCandidates(sampleRate,channels,128000)))?.config.codec||null;
  return out;
}

// 書き出しの準備。使えないときは {ok:false, reason} を返す（例外にはしない）。
// reason: no-video-encoder / module-load / no-video-codec / no-audio-encoder / no-audio-codec
export async function createMp4Writer({width,height,fps=30,bitrate=8000000,audio=false,
  sampleRate=48000,channels=2,audioBitrate=128000,keyFrameSeconds=2,maxQueue=4}={}){
  if(typeof VideoEncoder!=='function'||typeof VideoFrame!=='function') return {ok:false,reason:'no-video-encoder'};
  let Muxer,ArrayBufferTarget;
  try{ ({Muxer,ArrayBufferTarget}=await import(MUXER_URL)); }catch{ return {ok:false,reason:'module-load'}; }
  const video=await firstSupported(VideoEncoder,videoCandidates(width,height,fps,bitrate));
  if(!video) return {ok:false,reason:'no-video-codec'};
  let sound=null;
  if(audio){
    if(typeof AudioEncoder!=='function'||typeof AudioData!=='function') return {ok:false,reason:'no-audio-encoder'};
    sound=await firstSupported(AudioEncoder,audioCandidates(sampleRate,channels,audioBitrate));
    if(!sound) return {ok:false,reason:'no-audio-codec'};
  }

  const target=new ArrayBufferTarget();
  const muxer=new Muxer({target,fastStart:'in-memory',firstTimestampBehavior:'offset',
    video:{codec:video.mux,width,height,frameRate:fps},
    ...(sound?{audio:{codec:sound.mux,numberOfChannels:channels,sampleRate}}:{})});
  let encErr=null,frames=0,audioDone=false,closed=false;
  const t0=performance.now();
  const venc=new VideoEncoder({output:(chunk,meta)=>muxer.addVideoChunk(chunk,meta),error:e=>{encErr=encErr||e;}});
  venc.configure(video.config);
  const check=what=>{ if(encErr) throw new Error(`${what}のエンコードに失敗しました（${errorText(encErr)}）。`); };
  const close=()=>{ if(closed) return; closed=true; try{ if(venc.state!=='closed') venc.close(); }catch{} };

  return {
    ok:true,
    videoCodec:video.config.codec,
    audioCodec:sound?.config.codec||null,
    // source: canvas / ImageBitmap など VideoFrame にできるもの。index: 0 から始まるコマ番号。
    async addFrame(source,index){
      check('映像');
      const frame=new VideoFrame(source,{timestamp:Math.round(index*1e6/fps),duration:Math.round(1e6/fps)});
      venc.encode(frame,{keyFrame:index%Math.max(1,Math.round(fps*keyFrameSeconds))===0});
      frame.close();frames++;
      while(venc.encodeQueueSize>maxQueue&&!encErr) await sleep(4);
      check('映像');
    },
    // buffer: AudioBuffer（sampleRate が createMp4Writer と同じもの）。1回だけ呼ぶ。
    async addAudio(buffer){
      if(!sound) throw new Error('音なしで準備した書き出しには音を入れられません。');
      if(audioDone) throw new Error('音はすでに入っています。');
      if(buffer.sampleRate!==sampleRate) throw new Error(`音のサンプルレートが違います（${buffer.sampleRate}Hz、必要なのは${sampleRate}Hz）。`);
      audioDone=true;
      let aErr=null,first=true;
      const fallback=fallbackAacConfig(sampleRate,channels);
      const aenc=new AudioEncoder({output:(chunk,meta)=>{
        if(sound.mux!=='aac'){ muxer.addAudioChunk(chunk,meta); return; }
        const bytes=new Uint8Array(chunk.byteLength);chunk.copyTo(bytes);
        // ADTS のヘッダー付き（0xFFF で始まる）なら、MP4 には生の AAC を入れるためヘッダーを外す。
        const adts=bytes.length>7&&bytes[0]===0xff&&(bytes[1]&0xf0)===0xf0;
        const out=adts?new EncodedAudioChunk({type:chunk.type,timestamp:chunk.timestamp,duration:chunk.duration??undefined,data:bytes.subarray((bytes[1]&1)?7:9)}):chunk;
        let m=meta;
        if(first){
          const raw=meta?.decoderConfig?.description;
          const rb=raw?new Uint8Array(raw.buffer||raw,raw.byteOffset||0,raw.byteLength):null;
          const asc=aacSpecificConfig(rb);
          m={...(meta||{}),decoderConfig:{...(meta?.decoderConfig||{}),codec:'mp4a.40.2',sampleRate,numberOfChannels:channels,
            description:asc&&asc.length>=2?asc:fallback}};
          first=false;
        }
        muxer.addAudioChunk(out,m);
      },error:e=>{aErr=aErr||e;}});
      aenc.configure(sound.config);
      const planes=[];
      for(let c=0;c<channels;c++) planes.push(buffer.getChannelData(Math.min(c,buffer.numberOfChannels-1)));
      try{
        for(let at=0;at<buffer.length;at+=1024){
          if(aErr) break;
          const n=Math.min(1024,buffer.length-at),d=new Float32Array(n*channels);
          planes.forEach((p,c)=>d.set(p.subarray(at,at+n),c*n));
          const ad=new AudioData({format:'f32-planar',sampleRate,numberOfFrames:n,numberOfChannels:channels,timestamp:Math.round(at/sampleRate*1e6),data:d});
          aenc.encode(ad);ad.close();
          while(aenc.encodeQueueSize>16&&!aErr) await sleep(2);
        }
        if(!aErr) await aenc.flush();
      }finally{ try{ if(aenc.state!=='closed') aenc.close(); }catch{} }
      if(aErr) throw new Error(`音のエンコードに失敗しました（${errorText(aErr)}）。`);
    },
    async finish(){
      check('映像');
      await venc.flush();close();
      check('映像');
      muxer.finalize();
      const blob=new Blob([target.buffer],{type:'video/mp4'});
      if(!blob.size) throw new Error('動画データを作成できませんでした。');
      return {blob,stats:{videoCodec:video.config.codec,audioCodec:audioDone?sound.config.codec:null,frames,fps,
        bytes:blob.size,totalMs:Math.round(performance.now()-t0)}};
    },
    // 中止。以後このライターは使えない。
    cancel(){ close(); },
  };
}
