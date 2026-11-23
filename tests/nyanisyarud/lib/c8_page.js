// Corner 8 right after the shortcut branch: brake -> release -> paw, from the outside or inside lane.
(()=>{const realNow=Date.now.bind(Date),realPerf=performance.now.bind(performance);const clock={base:realNow(),pbase:realPerf(),ms:0};Date.now=()=>clock.base+clock.ms;performance.now=()=>clock.pbase+clock.ms;
window.__C8=function(lane,relBrake,relRelease,kmh){const lt=document.getElementById('launchTitle');if(lt)lt.hidden=true;if(currentKey!=='irohaLocal')rebuildTrack('irohaLocal');if(catModel!=='nekomata')setCatModel('nekomata');if(driveMode!=='gachiTouge')setDriveMode('gachiTouge');
  if(gameState!=='ready')resetRace();startRace();countdown.active=false;const c=DRIVING_GUIDE_DATA.tracks.irohaLocal.corners.find(x=>x.number===8),dt=1/60;
  s=c.start-60;lateral=lane;speed=kmh/3.6;resetPathHandling();resetSteeredLine();resetCornerPace();resetCornerDrive();joyActive=true;joyVec.x=0;input.brake=false;input.drift=false;
  const step=()=>{clock.ms+=dt*1000;advanceGameFrame(dt);};let maxLink=0,grade=null,jump=false,pawDone=false,released=false;
  for(let i=0;i<400&&s<c.end+10;i++){const rel=s-c.start;const lv=pathHandling.ready?pathHandling.lateralVelocity:0;
   let st=THREE.MathUtils.clamp((lane-(lateral+lv*.3))-lv*.2,-1,1);if(rel>relBrake)st=1;joyVec.x=st;
   input.brake=rel>=relBrake&&rel<relRelease;if(rel>=relRelease)released=true;
   input.drift=released&&!pawDone&&rel<relRelease+3;if(released&&rel>=relRelease+3)pawDone=true;
   step();if(cornerDrive&&cornerDrive.corner===c)maxLink=Math.max(maxLink,cornerDrive.link||0);
   if(fBrakeAssessment&&fBrakeAssessment.corner===8)grade=fBrakeAssessment.rank;if(irohaJumpDone||irohaOnJumpCurve)jump=true;}
  input.brake=false;input.drift=false;joyVec.x=0;joyActive=false;return {grade,maxLink,jump};};return true;})()
