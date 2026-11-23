#!/usr/bin/env node
// nyanisyarud F-physics regression suite (real input path: joystick/keys -> pollKeys -> tick).
// Usage: node run.js [--target ../../nyanisyarudC113.html] [--baseline baseline.json] [--ref <older build>] [--update] [--only a,b]
// Groups: nonf (needs --ref), digital, meat, theory, shortcut, swipe, c8, wind (C114以降).
// --update writes baseline.json from the target; otherwise results are compared to it.
const fs=require('fs');const path=require('path');const {load}=require('./lib/load.js');
const arg=(k,d)=>{const i=process.argv.indexOf(k);return i>0?process.argv[i+1]:d;};
const TARGET=path.resolve(arg('--target',path.join(__dirname,'../../nyanisyarudC113.html')));
const REF=arg('--ref',null),UPDATE=process.argv.includes('--update');
const BASE=path.resolve(__dirname,arg('--baseline','baseline.json'));
const ONLY=(arg('--only','')||'').split(',').filter(Boolean);
const want=g=>!ONLY.length||ONLY.includes(g);
const HARNESS=fs.readFileSync(path.join(__dirname,'lib/harness_page.js'),'utf8');
const F='linephysics=F&c11diag=1';
async function withPage(file,query,src,fn){const {b,p,errs}=await load(file,query);try{if(src)await p.evaluate(s=>window.__T.ev(s),src);return await fn(p,errs);}finally{await b.close();}}
const run=(p,P)=>p.evaluate(P=>window.__H.run(P),P);
const pick=r=>({time:+r.time.toFixed(4),wall:r.wall,ex10:r.latProf?.exit10==null?null:+r.latProf.exit10.toFixed(3),slideT:+(r.slideT||0).toFixed(3),slideOut:+(r.slideOut||0).toFixed(3),lv:r.receipt?.level||0});
const DIGI={spawnBack:60,spawnKmh:120,finishAfter:45,decel:20,line:'oio',digital:true,outer:2.3,inner:3,apex:.5,exit:10,exitLat:2,look:.3,kp:1,kd:.2,turnIn:-10};
const groups={
  async nonf(){
    if(!REF)return {skipped:'no --ref'};
    const out={};
    for(const q of ['c11diag=1','linephysics=A&c11diag=1']){
      const runs=[];for(const corner of [2,10])for(const Ve of [40,55,70])for(const line of ['iii','oio'])
        runs.push({corner,spawnBack:55,spawnKmh:90,finishAfter:45,look:.3,kp:.9,kd:.25,decel:20,brakeEnd:-5,Ve,paw:false,line,inner:2.6,outer:2.6,turnIn:-5,apex:.55,exit:10,exitLat:2.0});
      const a=await withPage(TARGET,q,HARNESS,async p=>{const r=[];for(const P of runs)r.push(pick(await run(p,P)));return r;});
      const b=await withPage(path.resolve(REF),q,HARNESS,async p=>{const r=[];for(const P of runs)r.push(pick(await run(p,P)));return r;});
      out[q]={identical:a.every((x,i)=>x.time===b[i].time&&x.wall===b[i].wall),n:runs.length};
    }
    return out;
  },
  async digital(){
    return withPage(TARGET,F,HARNESS,async p=>{const r=[];
      for(const corner of [1,2,3,6,7,9])for(const [Ve,brakeEnd] of [[45,-10],[60,-8],[70,0]])for(const holdUntil of [.5,1.2])
        r.push({case:[corner,Ve,brakeEnd,holdUntil],...pick(await run(p,{...DIGI,paw:false,corner,Ve,brakeEnd,holdUntil}))});
      return r;});
  },
  async meat(){
    return withPage(TARGET,F,HARNESS,async p=>{const r=[];
      for(const corner of [1,2,3,4,6,7,9])for(const Ve of [50,60,70])for(const holdUntil of [.5,1.2])
        r.push({case:[corner,Ve,holdUntil],...pick(await run(p,{...DIGI,paw:true,pawAt:-4,pawHold:.2,pawSteer:0,pawSteerUntil:0,brakeEnd:-8,corner,Ve,holdUntil}))});
      return r;});
  },
  async theory(){
    const sets=JSON.parse(fs.readFileSync(path.join(__dirname,'fixtures/theory_sets.json'),'utf8'));
    return withPage(TARGET,F+'&fscrub=0.5',HARNESS,async p=>{const r={};
      for(const [key,x] of Object.entries(sets)){const [c,mode,line]=key.split(' ');
        r[key]=pick(await run(p,{corner:+c,spawnBack:55,spawnKmh:90,finishAfter:45,decel:20,line,paw:mode==='paw',...x}));}
      for(const c of ['10','2'])for(const m of ['grip','paw'])r[`gap ${c} ${m}`]=+(r[`${c} ${m} oio`].time-r[`${c} ${m} iii`].time).toFixed(4);
      return r;});
  },
  async shortcut(){
    const src=fs.readFileSync(path.join(__dirname,'lib/shortcut_page.js'),'utf8');
    return withPage(TARGET,F,src,async p=>{let jumped=0,n=0;const ranks={};
      for(const kmh of [95,110,125])for(const lane of [1.8,2.4,2.9])for(const steerFrom of [-14,-9,-5])for(const [brakeFrom,brakeTo] of [[-12,-2],[-9,1],[-6,4]]){
        const r=await p.evaluate(P=>window.__SC(P),{spawn:-110,kmh,lane,steerFrom,steerTo:brakeTo+.5,brakeFrom,brakeTo});n++;
        if(r.jumped){jumped++;const k=r.attempt?.rank||'?';ranks[k]=(ranks[k]||0)+1;}}
      return {jumped,n,ranks};});
  },
  async c8(){
    const src=fs.readFileSync(path.join(__dirname,'lib/c8_page.js'),'utf8');
    return withPage(TARGET,F,src,async p=>{const r=[];
      for(const a of [[-1.8,-25,-12,110],[-1.8,-20,-6,110],[-1.8,-15,-2,100],[2.4,-25,-12,110],[2.4,-20,-6,110]])r.push({case:a,...await p.evaluate(a=>window.__C8(...a),a)});
      return r;});
  },
  async wind(){
    const src=fs.readFileSync(path.join(__dirname,'lib/wind_page.js'),'utf8');
    return withPage(TARGET,'linephysics=F',null,async p=>{
      if(!await p.evaluate(()=>window.__T.ev('typeof fBay777Plan==="function"')))return {skipped:'no bay777 wind'};
      await p.evaluate(s=>window.__T.ev(s),src);const W=P=>p.evaluate(P=>window.__WIND(P),P);
      return {gate:await p.evaluate(()=>window.__WINDGATE()),
        free:await W({mode:'free',kmh:260}),counter:await W({mode:'counter',kmh:260,delay:.3}),
        sapo:await W({mode:'counter',kmh:250,delay:.3,dm:'nyanSapo'}),redcat:await W({mode:'free',kmh:777,cat:'redcat'})};});
  },
  async swipe(){
    const src=fs.readFileSync(path.join(__dirname,'lib/swipe_page.js'),'utf8');
    return withPage(TARGET,F,src,async p=>({keyboard:await p.evaluate(()=>window.__SW('keyboard')),swipe:await p.evaluate(()=>window.__SW('swipe'))}));
  }
};
(async()=>{
  const names=Object.keys(groups).filter(want);
  const results=Object.fromEntries(await Promise.all(names.map(async n=>[n,await groups[n]()])));
  const base=fs.existsSync(BASE)?JSON.parse(fs.readFileSync(BASE,'utf8')):{};
  fs.writeFileSync(path.join(__dirname,'results.json'),JSON.stringify(results,null,1));
  if(UPDATE){fs.writeFileSync(BASE,JSON.stringify({...base,...results},null,1));console.log('baseline updated:',names.join(','));}
  let fail=0;const say=(ok,msg)=>{if(!ok)fail++;console.log((ok?'PASS ':'FAIL ')+msg);};
  if(results.nonf&&!results.nonf.skipped)for(const [q,v] of Object.entries(results.nonf))say(v.identical,`nonf ${q}: ${v.n} runs identical to --ref`);
  // 判定の中身(ブレーキの判定・連携・受け取り)も基準と比べる。形だけの確認では、判定が全部WEAKに変わっても合格してしまうため
  const same=(a,b)=>JSON.stringify(a)===JSON.stringify(b);
  if(results.swipe){const k=results.swipe.keyboard,w=results.swipe.swipe;
    say(Boolean(w.link)&&w.brakeType===k.brakeType&&w.sliding,`swipe: brake ${w.brakeType}/${k.brakeType}, link ${w.link}/${k.link}, sliding ${w.sliding}`);
    if(base.swipe)say(same(results.swipe,base.swipe)||UPDATE,`swipe: identical to baseline (brake/link/receipt)`);}
  if(results.c8){const r=results.c8;
    say(r.slice(0,4).every(x=>x.grade&&!x.jump)&&r[4].jump,`c8: grades ${r.map(x=>x.jump?'JUMP':(x.grade||'-')).join(',')} (outside/early releases graded; inside release in the takeoff window jumps)`);
    if(base.c8){const b=base.c8,diff=r.filter((x,i)=>!same(x,b[i]));
      say(diff.length===0||UPDATE,`c8: identical to baseline (grade/link/jump)${diff.length?' changed: '+diff.map(x=>JSON.stringify(x.case)+' '+x.grade+'/'+x.maxLink+(x.jump?'/JUMP':'')).join('; ')+' baseline '+b.map(x=>x.jump?'JUMP':(x.grade||'-')).join(','):''}`);}}
  if(results.wind&&!results.wind.skipped){const w=results.wind,g=w.gate;
    say(g['nekomata/gachiTouge']==='normal'&&g['nekomata/nyanSapo']==='sapo'&&g['redcat/gachiTouge']==='redcat'&&g['redcat/nyanSapo']==='redcat'&&g['suberi/gachiTouge']===null,`wind gate: ${JSON.stringify(g)}`);
    // 壁に当たると速さが2割落ち、低速では風が弱まる(救済)ので、何もしない時の接触は3分の1以上を合格とする
    say(w.free.lobesHit*3>=w.free.lobes,`wind free 260km/h: ${w.free.lobesHit}/${w.free.lobes} 回の向きで壁接触 (3分の1以上)`);
    say(w.counter.walls===0&&w.counter.done,`wind counter 260km/h 反応0.3秒: 壁 ${w.counter.walls} 横 ${w.counter.lat}`);
    say(w.sapo.walls===0&&w.sapo.done,`wind にゃんサポ counter 250km/h: 壁 ${w.sapo.walls} 横 ${w.sapo.lat}`);
    say(w.redcat.zmode==='redcat'&&w.redcat.arrowFrames>0&&w.redcat.done,`wind REDCAT 777km/h: 矢印 ${w.redcat.arrowFrames}コマ 壁 ${w.redcat.walls}`);}
  if(results.shortcut){const b=base.shortcut;say(!b||results.shortcut.jumped>=b.jumped,`shortcut: jumped ${results.shortcut.jumped}/${results.shortcut.n} (baseline ${b?b.jumped:'-'}) ${JSON.stringify(results.shortcut.ranks)}`);}
  for(const g of ['digital','meat']){if(!results[g])continue;const b=base[g];
    const tot=results[g].reduce((a,x)=>a+x.time,0),walls=results[g].reduce((a,x)=>a+x.wall,0);
    const diff=b?results[g].filter((x,i)=>Math.abs(x.time-b[i].time)>1e-4||x.wall!==b[i].wall).length:0;
    console.log(`INFO ${g}: total ${tot.toFixed(2)}s walls ${walls} changed-vs-baseline ${diff}/${results[g].length}`);
    if(b)say(diff===0||UPDATE,`${g}: identical to baseline`);}
  if(results.theory){const t=results.theory,b=base.theory;
    for(const k of Object.keys(t).filter(k=>k.startsWith('gap')))console.log(`INFO theory ${k}: ${t[k].toFixed(3)}s (OIO-III)${b?' baseline '+b[k].toFixed(3):''}`);
    // 83° grip/paw and 162° paw: OIO faster. 162° grip: parity within +-0.15 s (optimizer noise).
    say(['gap 10 grip','gap 10 paw','gap 2 paw'].every(k=>t[k]<0)&&Math.abs(t['gap 2 grip'])<=.15,
      'theory: OIO faster in 83° grip/paw and 162° paw; 162° grip within +-0.15 s');}
  process.exitCode=fail?1:0;
})();
