// Mobile swipe (brake held -> slide onto paw button) vs keyboard order (release, then paw).
(()=>{
const realNow=Date.now.bind(Date),realPerf=performance.now.bind(performance);
const clock={base:realNow(),pbase:realPerf(),ms:0};Date.now=()=>clock.base+clock.ms;performance.now=()=>clock.pbase+clock.ms;
window.__SW=function(mode){
  const lt=document.getElementById('launchTitle');if(lt)lt.hidden=true;
  if(currentKey!=='irohaLocal')rebuildTrack('irohaLocal');if(catModel!=='nekomata')setCatModel('nekomata');if(driveMode!=='gachiTouge')setDriveMode('gachiTouge');
  if(gameState!=='ready')resetRace();startRace();countdown.active=false;
  const c=DRIVING_GUIDE_DATA.tracks.irohaLocal.corners.find(x=>x.number===2),dt=1/60;
  s=c.start-24;lateral=-.5;speed=78/3.6;resetPathHandling();resetSteeredLine();resetCornerPace();resetCornerDrive();
  joyActive=true;joyVec.x=0;input.brake=false;input.drift=false;input.brakePressed=false;input.driftPressed=false;
  const step=()=>{clock.ms+=dt*1000;advanceGameFrame(dt);};
  for(let i=0;i<20;i++)step();
  joyVec.x=1;setBrake(true);for(let i=0;i<40;i++)step();
  if(mode==='swipe'){const orig=isPointInside;isPointInside=()=>true;try{handleSlideGesture(0,0);}finally{isPointInside=orig;}step();}
  else{setBrake(false);step();setDrift(true);step();}
  const after={sliding:isSliding,brakeType:brakeJustType||null,link:meatLinkContext?meatLinkContext.brakeType:null,solo:slideSolo};
  for(let i=0;i<20;i++)step();
  setBrake(false);setDrift(false);for(let i=0;i<5;i++)step();
  return {...after,receipt:cornerDrive?{level:cornerDrive.level,link:cornerDrive.link,method:cornerDrive.method}:null};
};return true;})()
