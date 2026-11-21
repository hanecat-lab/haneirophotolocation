// Evaluated inside the game module via window.__T.ev. Test-only; never shipped.
(()=>{
const realNow=Date.now.bind(Date),realPerf=performance.now.bind(performance);
const clock={base:realNow(),pbase:realPerf(),ms:0};
Date.now=()=>clock.base+clock.ms;performance.now=()=>clock.pbase+clock.ms;
function smooth(x,a,b){if(b<=a)return x>=b?1:0;const t=THREE.MathUtils.clamp((x-a)/(b-a),0,1);return t*t*(3-2*t);}
function lineTarget(d,c,P){
  const dir=c.dir||1,len=c.end-c.start;
  if(P.line==='iii'){return dir*P.inner;}
  const turnIn=c.start+P.turnIn,apex=c.start+len*P.apex,exit=c.end+P.exit;
  if(d<turnIn)return -dir*P.outer;
  if(d<apex)return dir*(-P.outer+(P.inner+P.outer)*smooth(d,turnIn,apex));
  return dir*(P.inner+(-P.exitLat-P.inner)*smooth(d,apex,exit));
}
function setup(track='irohaLocal'){
  const lt=document.getElementById('launchTitle');if(lt)lt.hidden=true;
  if(currentKey!==track)rebuildTrack(track);
  if(catModel!=='nekomata')setCatModel('nekomata');
  if(driveMode!=='gachiTouge')setDriveMode('gachiTouge');
}
function run(P){
  const track=P.track||'irohaLocal';setup(track);
  if(gameState!=='ready')resetRace();
  if(racePause.on)setPause(false);
  const app=document.getElementById('app');app.dataset.raceMenu='off';
  startRace();
  if(gameState!=='racing')return {ok:false,error:'not racing',gs:gameState};
  countdown.active=false;
  const c=DRIVING_GUIDE_DATA.tracks[track].corners.find(x=>x.number===P.corner);
  if(P.VeFactor){let kmax=0;for(let d=c.start;d<=c.end;d+=2)kmax=Math.max(kmax,Math.abs(roadBendAt(d)));P={...P,Ve:cornerGripSpeed(kmax)*3.6*P.VeFactor};}
  const dt=1/60;
  s=c.start-P.spawnBack;lateral=lineTarget(s,c,P);speed=P.spawnKmh/3.6;elapsed=0;simulationElapsed=0;
  resetPathHandling();resetSteeredLine();resetCornerPace();resetCornerDrive();
  input.steer=0;input.brake=false;input.drift=false;input.brakePressed=false;input.driftPressed=false;
  joyActive=true;joyVec.x=0;lastWallHitTime=-99;
  const finish=c.end+P.finishAfter;
  let t=0,wall=0,lastCooldown=0,frames=0,brakeSec=0,scrubSum=0,underMax=0,minKmh=1e9,entry=null,exit=null,apexKmh=null;
  let slideOut=0,slideT=0,prevLat=null,latProf={pushMin:9,exit10:null,exit30:null},exitStats={reasons:{},t:0,accelSum:0,ordSum:0,planSum:0},brakeTurn={t:0,kmh:0,over:0},bdFrames=0,quals={},brakeType=null,linkFlag=null;let lastBrake=false,brakeRelease=null,pawStart=null,pawDone=false,lv=0,maxScale=1,receipt=null,slid=0,maxExcess=0;
  const trace=[];
  let prevS=s,prevT=0,fOn=0,fFrames=0;
  while(s<finish&&t<30&&gameState==='racing'){prevS=s;prevT=t;
    lv=pathHandling.ready?pathHandling.lateralVelocity:0;
    const look=P.look,target=lineTarget(s+speed*.62*look,c,P),proj=lateral+lv*look;
    let steer=THREE.MathUtils.clamp((target-proj)*P.kp-lv*P.kd,-1,1);
    if(P.digital){const dir=c.dir||1,ins=lateral*dir,len=c.end-c.start,rel=s-c.start;
      if(rel<P.turnIn)steer=ins>-P.outer+.3?-dir:0;
      else if(rel<len*P.holdUntil)steer=dir;
      else steer=P.exitPress&&rel<len*P.holdUntil+P.exitPress?-dir:0;}
    // Speed policy: brake until Ve at s=brakeEnd; never brake afterwards.
    const brakeEnd=c.start+P.brakeEnd;let brake=false;
    if(s<brakeEnd){const need=speed*speed-(P.Ve/3.6)**2;brake=need>0&&need>=2*P.decel*(brakeEnd-s)-(lastBrake?1.5:0);}
    if(P.paw&&(P.pawAt!==undefined?(s>=c.start+P.pawAt&&!brake):brakeRelease!==null)&&!pawDone){
      if(pawStart===null&&(P.pawAt!==undefined||t-brakeRelease>=P.pawDelay))pawStart=t;
      if(pawStart!==null){if(t-pawStart>=P.pawHold)pawDone=true;}
    }
    const paw=Boolean(P.paw&&pawStart!==null&&!pawDone);
    // A paw steer bias toward the inside while sliding (drift angle request).
    let cmdSteer=steer;
    if(brake&&P.brakeSteer)cmdSteer=THREE.MathUtils.clamp(steer+P.brakeSteer*(c.dir||1),-1,1);
    if((paw||isSliding)&&P.pawSteer&&s<c.end+P.pawSteerUntil)cmdSteer=THREE.MathUtils.clamp(steer+P.pawSteer*(c.dir||1),-1,1);
    joyActive=true;joyVec.x=cmdSteer;
    input.brake=brake;input.drift=paw;
    if(lastBrake&&!brake&&brakeRelease===null)brakeRelease=t;
    lastBrake=brake;
    clock.ms+=dt*1000;
    advanceGameFrame(dt);fFrames++;if(linePhysicsBEnabled())fOn++;
    t+=dt;frames++;if(brake)brakeSec+=dt;if(isSliding)slid+=dt;
    if(wallHitCooldown>lastCooldown+1e-6)wall++;lastCooldown=wallHitCooldown;
    const d=fC94DriveDiag;if(d){scrubSum+=(d.scrubDecel||0)*dt;underMax=Math.max(underMax,d.understeer||0);maxScale=Math.max(maxScale,d.tireScale||1);}
    if(cornerDrive&&cornerDrive.corner===c){const r0=receipt||{level:0,link:0,hold:false,cancel:false};receipt={level:Math.max(r0.level,cornerDrive.level||0),link:Math.max(r0.link,cornerDrive.link||0),method:cornerDrive.method,hold:r0.hold||Boolean(cornerDrive.fHoldEntryReady),cancel:r0.cancel||Boolean(cornerDrive.exitCancelled)};}
    if(isSliding&&slideLastQuality)quals[slideLastQuality]=(quals[slideLastQuality]||0)+1;if(brakeJustType)brakeType=brakeJustType;if(isBrakingDrift)bdFrames++;if(meatLinkContext)linkFlag=meatLinkContext.brakeType;
    if(brake&&pathHandling.ready){const f=linePhysicsATireForce(true,fDriftTireScale());const u=speed*speed*(pathHandling.turnCurvature||0)/Math.max(1,f);
      if(u>.5){brakeTurn.t+=dt;brakeTurn.kmh+=24*dt*3.6;}brakeTurn.over+=Math.max(0,Math.hypot(Math.min(u,1.5),1)-1)*dt;}
    {const prof=getCornerDriveProfile(c);if(s>=prof.apex&&s<=c.end+20&&!brake){exitStats.t+=dt;const rs=d?.reason||'none';exitStats.reasons[rs]=(exitStats.reasons[rs]||0)+dt;exitStats.accelSum+=(d?.engineAccel??0)*dt;exitStats.ordSum+=ordinaryAcceleration(speed)*dt;exitStats.planSum+=(d?.plannedAccel??0)*dt;}}
    {const dir=c.dir||1,ins=lateral*dir,len=c.end-c.start;if(s>c.start+len*.5&&s<c.end)latProf.pushMin=Math.min(latProf.pushMin,ins);
     if(latProf.exit10===null&&s>=c.end+10)latProf.exit10=ins;if(latProf.exit30===null&&s>=c.end+30)latProf.exit30=ins;}
    if(isSliding){slideT+=dt;if(prevLat!==null)slideOut+=Math.max(0,-(lateral-prevLat)*(c.dir||1));}prevLat=lateral;
    minKmh=Math.min(minKmh,speed*3.6);
    if(entry===null&&s>=c.start)entry={t,kmh:speed*3.6};
    if(exit===null&&s>=c.end)exit={t,kmh:speed*3.6};
    if(P.trace&&frames%3===0)trace.push([+s.toFixed(1),+lateral.toFixed(2),+(speed*3.6).toFixed(1),brake?1:0,isSliding?1:0,+(d?.shortfall||0).toFixed(3),+(d?.scrubDecel||0).toFixed(2),d?.reason||'']);
  }
  input.brake=false;input.drift=false;joyVec.x=0;joyActive=false;
  const tf=s>=finish&&s>prevS?prevT+(t-prevT)*(finish-prevS)/(s-prevS):t;
  return {ok:s>=finish,time:tf,fOnShare:fFrames?fOn/fFrames:0,Ve:P.Ve,wall,entry,exit,finishKmh:speed*3.6,minKmh,brakeSec,scrubLossKmh:scrubSum*3.6,underMax,maxScale,receipt,slid,quals,brakeType,linkFlag,bdFrames,brakeTurn,exitStats,latProf,slideOut,slideT,
    coreTime:exit&&entry?exit.t-entry.t:null,afterTime:exit?t-exit.t:null,trace:P.trace?trace:undefined};
}
window.__H={run,lineTarget};
return true;
})()
