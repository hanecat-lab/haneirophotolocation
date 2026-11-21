(()=>{
const realNow=Date.now.bind(Date),realPerf=performance.now.bind(performance);
const clock={base:realNow(),pbase:realPerf(),ms:0};Date.now=()=>clock.base+clock.ms;performance.now=()=>clock.pbase+clock.ms;
function setup(){const lt=document.getElementById('launchTitle');if(lt)lt.hidden=true;if(currentKey!=='irohaLocal')rebuildTrack('irohaLocal');if(catModel!=='nekomata')setCatModel('nekomata');if(driveMode!=='gachiTouge')setDriveMode('gachiTouge');}
window.__SC=function(P){
  setup();if(gameState!=='ready')resetRace();if(racePause.on)setPause(false);document.getElementById('app').dataset.raceMenu='off';
  startRace();countdown.active=false;const dt=1/60;
  s=branchS+P.spawn;lateral=P.lane;speed=P.kmh/3.6;elapsed=0;simulationElapsed=0;
  resetPathHandling();resetSteeredLine();resetCornerPace();resetCornerDrive();
  input.steer=0;input.brake=false;input.drift=false;joyActive=true;joyVec.x=0;
  let t=0,minF=1,fOff=0,frames=0,maxS=s,reserved=false,jumped=false,attempt=null;const trace=[];
  while(t<12&&gameState==='racing'){
    const rel=s-branchS,lv=pathHandling.ready?pathHandling.lateralVelocity:0;
    let steer=THREE.MathUtils.clamp((P.lane-(lateral+lv*.3))*1.0-lv*.2,-1,1);
    if(rel>=P.steerFrom&&rel<P.steerTo)steer=1;
    const brake=rel>=P.brakeFrom&&rel<P.brakeTo;
    joyVec.x=steer;input.brake=brake;clock.ms+=dt*1000;advanceGameFrame(dt);t+=dt;frames++;
    if(!linePhysicsBEnabled()&&rel>-95&&rel<10)fOff++;
    if(irohaJumpReserved)reserved=true;if(irohaJumpDone)jumped=true;
    if(irohaEntryAttempt&&!attempt)attempt={rank:irohaEntryAttempt.rank,reason:irohaEntryAttempt.reason,kmh:irohaEntryAttempt.kmh,angle:irohaEntryAttempt.angle,lat:irohaEntryAttempt.lateralError};
    if(P.trace&&frames%4===0&&rel>-30&&rel<12)trace.push([+rel.toFixed(1),+lateral.toFixed(2),+(speed*3.6).toFixed(0),brake?1:0,+(relYaw*180/Math.PI).toFixed(0),linePhysicsBEnabled()?'F':'-']);
    if(jumped&&landingPhase==='none'&&!isLandingLocked&&s>branchS+100)break;
    if(!reserved&&!irohaOnJumpCurve&&s>branchS+60)break;
  }
  input.brake=false;joyVec.x=0;joyActive=false;
  return {reserved,jumped,attempt,fOffFrames:fOff,s:+(s-branchS).toFixed(1),t:+t.toFixed(2),trace:P.trace?trace:undefined};
};return true;})()
