// Evaluated inside the game module via window.__T.ev. Test-only; never shipped.
// 湾岸777の横風(C114)：大橋〜料金所手前を走り、壁接触の回数と横位置の幅を返す。
(()=>{
const clock={ms:0},b0=Date.now(),p0=performance.now();
Date.now=()=>b0+clock.ms;performance.now=()=>p0+clock.ms;
function setup(cat,dm){const lt=document.getElementById('launchTitle');if(lt)lt.hidden=true;
  if(currentKey!=='bay777')rebuildTrack('bay777');catModel=cat;setDriveMode(dm);}
// mode: free=操作なし / counter=反応遅れdelay秒で横位置0へ当て舵(P制御)
function run({mode='free',kmh=260,delay=0,cat='nekomata',dm='gachiTouge'}){
  setup(cat,dm);if(gameState!=='ready')resetRace();if(racePause.on)setPause(false);
  document.getElementById('app').dataset.raceMenu='off';startRace();countdown.active=false;
  const zmode=fBay777Mode(),Z=fBay777Zone();if(!Z)return {zmode,off:true};
  const dt=1/60;s=Z.start-150;lateral=0;speed=kmh/3.6;elapsed=0;simulationElapsed=0;
  resetPathHandling();resetSteeredLine();resetCornerPace();resetCornerDrive();
  input.steer=0;input.brake=false;input.drift=false;joyActive=true;joyVec.x=0;lastWallHitTime=-99;
  bay777Run.fz=null;fBay777Prev.s=s;fBay777Prev.windHit.clear();
  let t=0,lc=0,walls=0,lo=9,hi=-9,arrow=0,pl=lateral;const hist=[];
  while(s<Z.end+30&&t<80&&gameState==='racing'){
    const lv=cat==='redcat'?(lateral-pl)/dt:(pathHandling.ready?pathHandling.lateralVelocity:0);pl=lateral;hist.push([lateral,lv]);
    const [la,lva]=hist[Math.max(0,hist.length-1-Math.round(delay/dt))];
    joyVec.x=mode==='free'?0:THREE.MathUtils.clamp(-(la+lva*.35)*1.2-lva*.25,-1,1);
    input.brake=speed*3.6>kmh+4;
    clock.ms+=dt*1000;advanceGameFrame(dt);updateBay777();t+=dt;
    if(wallHitCooldown>lc+1e-6)walls++;lc=wallHitCooldown;
    if(s>Z.start&&s<Z.end){lo=Math.min(lo,lateral);hi=Math.max(hi,lateral);const el=document.querySelector('.bay777-wind-arrow');if(el&&!el.hidden)arrow++;}
  }
  return {zmode,lobes:Z.lobes.length,lobesHit:fBay777Prev.windHit.size,walls,lat:[+lo.toFixed(2),+hi.toFixed(2)],arrowFrames:arrow,done:s>=Z.end};
}
// 横風が吹く猫の判定：普通猫(ガチ峠・にゃんサポ)・REDCAT・すべり猫
function gate(){setup('nekomata','gachiTouge');const out={};
  for(const [cat,dm] of [['nekomata','gachiTouge'],['nekomata','nyanSapo'],['redcat','gachiTouge'],['redcat','nyanSapo'],['suberi','gachiTouge']]){catModel=cat;setDriveMode(dm);out[cat+'/'+dm]=fBay777Mode();}
  catModel='nekomata';setDriveMode('gachiTouge');return out;}
window.__WIND=run;window.__WINDGATE=gate;
})();
