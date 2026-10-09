/* hitome v3.17 notifications only. Separate scope; no fetch cache, no root SW replacement. */
'use strict';
self.addEventListener('install',event=>event.waitUntil(self.skipWaiting()));
function notificationURL(raw){const fallback=new URL('../snslink.html',self.location.href);try{const url=new URL(String(raw||''),fallback);return url.origin===self.location.origin&&url.protocol==='https:'?url.href:fallback.href}catch{return fallback.href}}
self.addEventListener('push',event=>{
 let raw={};try{raw=event.data?.json()||{}}catch{raw={body:event.data?.text()||''}}
 const payload=raw.notification&&typeof raw.notification==='object'?raw.notification:raw;
 const data=payload.data&&typeof payload.data==='object'?payload.data:raw.data&&typeof raw.data==='object'?raw.data:{};
 const title=String(payload.title||'ひとめの予定').slice(0,120);
 const url=notificationURL(payload.url||data.url||raw.url);
 event.waitUntil(self.registration.showNotification(title,{
  body:String(payload.body||'予定を確認できます。').slice(0,280),
  icon:new URL('./icon-192.png',self.location.href).href,
  tag:String(payload.tag||payload.scheduleKey||raw.scheduleKey||'hitome:'+url),
  data:{url},renotify:false
 }));
});
self.addEventListener('notificationclick',event=>{
 event.notification.close();
 const url=notificationURL(event.notification.data?.url),target=new URL(url),taskId=target.searchParams.get('hitome-task');
 event.waitUntil((async()=>{
  const windows=await self.clients.matchAll({type:'window',includeUncontrolled:true});
  for(const client of windows){const current=new URL(client.url);if(current.origin===target.origin&&current.pathname===target.pathname){
   if(taskId)client.postMessage({type:'HITOME_OPEN_TASK',taskId});
   await client.focus();return;
  }}
  await self.clients.openWindow(url);
 })());
});
