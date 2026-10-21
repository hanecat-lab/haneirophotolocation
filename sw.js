const CACHE_NAME='event-flow-shell-v2';
// 外部の部品（CDN）の保存先。URLに版が入っているので中身は変わらない。
const CDN_CACHE='offline-cdn-v1';
const APP_SHELL=['./','./index.html','./manifest.webmanifest','./pwa-icon.svg','./icon-192.png','./icon-512.png','./apple-touch-icon.png'];
// 電波が弱い所・圏外でも開けるようにするページ。ほかのアプリのファイルは保存しない。
const OFFLINE_PAGES=['./event.html','./Vlog-Studio.html','./bokasi.html'];
// 外部の部品を保存するのは、このページが読み込んだものだけ。
const CDN_CLIENT_PAGES=['./Vlog-Studio.html','./bokasi.html'];
const NETWORK_TIMEOUT_MS=3000;
const pathOf=href=>new URL(href,self.location.href).pathname;
const KEEP_PATHS=new Set([...APP_SHELL,...OFFLINE_PAGES].map(pathOf));
const CDN_CLIENT_PATHS=new Set(CDN_CLIENT_PAGES.map(pathOf));
// 外部の部品を探す先（この2つのアプリが使う所）。それ以外の外部サイトへの読み込みには関わらない。
const CDN_HOSTS=new Set(['esm.sh','cdn.jsdelivr.net','fonts.googleapis.com','fonts.gstatic.com','cdn.tailwindcss.com','storage.googleapis.com','tfhub.dev','www.kaggle.com']);

self.addEventListener('install',event=>{
  event.waitUntil(caches.open(CACHE_NAME).then(cache=>Promise.allSettled(APP_SHELL.map(url=>cache.add(url)))));
  self.skipWaiting();
});

self.addEventListener('activate',event=>{
  event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key!==CACHE_NAME&&key!==CDN_CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim()));
});

// ページ: まずネットから取り、3秒で返らなければ保存してある版を出す。届いた分は次回のために保存する。
// ? 以降は無視して1件で保存する（診断用のURLごとに増えないように）。
async function pageResponse(event,url){
  const key=url.origin+url.pathname;
  const cache=await caches.open(CACHE_NAME);
  const network=fetch(event.request).then(response=>{
    if(response.ok)return cache.put(key,response.clone()).catch(()=>{}).then(()=>response);
    return response;
  });
  const cached=await cache.match(key);
  if(!cached){
    try{return await network;}
    catch{
      if(event.request.mode==='navigate')return (await cache.match(pathOf('./')))||(await cache.match(pathOf('./index.html')))||Response.error();
      return Response.error();
    }
  }
  const settled=network.catch(()=>null);
  const first=await Promise.race([settled,new Promise(resolve=>setTimeout(()=>resolve(null),NETWORK_TIMEOUT_MS))]);
  if(first&&first.ok)return first;
  // 遅い時は保存してある版を出し、ネットの分は裏で受け取り終えて保存する。
  event.waitUntil(settled);
  return cached;
}

// 外部の部品: Vlog-Studio と bokasi が読み込んだものだけ、保存してある版を先に使う。
async function cdnResponse(event){
  const client=event.clientId?await self.clients.get(event.clientId):null;
  if(!client||!CDN_CLIENT_PATHS.has(new URL(client.url).pathname))return fetch(event.request);
  return cacheFirst(event);
}

async function cacheFirst(event){
  const cache=await caches.open(CDN_CACHE);
  const cached=await cache.match(event.request);
  if(cached)return cached;
  const response=await fetch(event.request);
  if(response.ok||response.type==='opaque')event.waitUntil(cache.put(event.request,response.clone()).catch(()=>{}));
  return response;
}

self.addEventListener('fetch',event=>{
  const request=event.request;
  if(request.method!=='GET')return;
  const url=new URL(request.url);
  if(url.origin===self.location.origin){
    if(KEEP_PATHS.has(url.pathname))event.respondWith(pageResponse(event,url));
    return;
  }
  // フォント本体は、iPhone では読み込んだページが分からない（clientId が空）ことがあるため、ページに関係なく保存する。
  if(url.hostname==='fonts.gstatic.com'){event.respondWith(cacheFirst(event));return;}
  if(CDN_HOSTS.has(url.hostname)&&event.clientId)event.respondWith(cdnResponse(event));
});

self.addEventListener('push',event=>{
  let data={};
  try{data=event.data?.json()||{};}catch{data={body:event.data?.text()||''};}
  const title=String(data.title||'Event Flow');
  const options={
    body:String(data.body||'次のキューを確認してください。'),
    icon:'./icon-192.png',
    badge:'./icon-192.png',
    tag:String(data.tag||data.scheduleKey||'event-flow'),
    renotify:false,
    data:{url:String(data.url||'./')}
  };
  event.waitUntil(self.registration.showNotification(title,options));
});

self.addEventListener('notificationclick',event=>{
  event.notification.close();
  const target=new URL(event.notification.data?.url||'./',self.location.href).href;
  event.waitUntil(clients.matchAll({type:'window',includeUncontrolled:true}).then(windows=>{
    const existing=windows.find(client=>client.url===target);
    return existing?existing.focus():clients.openWindow(target);
  }));
});
