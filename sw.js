const CACHE_NAME='event-flow-shell-v2';
// 実機でどの版の sw.js が動いているかを sw-diag.html で見分けるための印。sw.js を変えたら更新する。
const SW_VERSION='2026-10-21-log2';
// 外部の部品とフォントをどう扱ったかの記録（sw-diag.html に表示する）。
const LOG_CACHE='sw-diag-log-v1';
const LOG_KEY=new URL('./__sw-diag-log.json',self.location.href).href;
const LOG_LIMIT=300;
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

// 同時に読み込みが走っても1つの配列を共有するよう、読み込みの約束ごと持つ。
let diagLog=null;
function loadLog(){
  if(!diagLog)diagLog=(async()=>{
    try{const saved=await (await caches.open(LOG_CACHE)).match(LOG_KEY);return saved?await saved.json():[];}catch{return [];}
  })();
  return diagLog;
}
// 書き込みは1件ずつ順に行う（同時に書くと、古い内容の書き込みが後から終わって記録が欠けるため）。
let logChain=Promise.resolve();
function writeLog(event,entry){
  const record={at:new Date().toISOString(),v:SW_VERSION,...entry};
  logChain=logChain.then(async()=>{
    const log=await loadLog();
    log.push(record);
    if(log.length>LOG_LIMIT)log.splice(0,log.length-LOG_LIMIT);
    await (await caches.open(LOG_CACHE)).put(LOG_KEY,new Response(JSON.stringify(log),{headers:{'content-type':'application/json'}}));
  }).catch(()=>{});
  event.waitUntil(logChain);
}
const requestInfo=event=>({url:event.request.url,dest:event.request.destination||'',mode:event.request.mode,client:!!event.clientId});

self.addEventListener('install',event=>{
  writeLog(event,{kind:'install'});
  event.waitUntil(caches.open(CACHE_NAME).then(cache=>Promise.allSettled(APP_SHELL.map(url=>cache.add(url)))));
  self.skipWaiting();
});

self.addEventListener('activate',event=>{
  writeLog(event,{kind:'activate'});
  event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key!==CACHE_NAME&&key!==CDN_CACHE&&key!==LOG_CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim()));
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
  if(!client||!CDN_CLIENT_PATHS.has(new URL(client.url).pathname)){
    writeLog(event,{kind:'cdn',...requestInfo(event),result:client?'other-page':'client-not-found'});
    return fetch(event.request);
  }
  return cacheFirst(event);
}

async function cacheFirst(event){
  const cache=await caches.open(CDN_CACHE);
  const info={kind:'cdn',...requestInfo(event)};
  const cached=await cache.match(event.request);
  if(cached){writeLog(event,{...info,result:'hit'});return cached;}
  let response;
  try{response=await fetch(event.request);}
  catch(error){writeLog(event,{...info,result:'fetch-error',detail:String(error?.message||error).slice(0,80)});throw error;}
  const store=response.ok||response.type==='opaque';
  if(store)event.waitUntil(cache.put(event.request,response.clone()).catch(error=>writeLog(event,{...info,result:'put-error',detail:String(error?.message||error).slice(0,80)})));
  writeLog(event,{...info,result:store?'stored':'not-stored',status:response.status,type:response.type});
  return response;
}

self.addEventListener('fetch',event=>{
  const request=event.request;
  if(request.method!=='GET')return;
  const url=new URL(request.url);
  if(url.origin===self.location.origin){
    // ページを開いた操作がこの版の sw.js に届いたかを記録する。
    if(request.mode==='navigate')writeLog(event,{kind:'page',url:request.url});
    if(KEEP_PATHS.has(url.pathname))event.respondWith(pageResponse(event,url));
    return;
  }
  // フォント本体は、iPhone では読み込んだページが分からない（clientId が空）ことがあるため、ページに関係なく保存する。
  if(url.hostname==='fonts.gstatic.com'){event.respondWith(cacheFirst(event));return;}
  if(!CDN_HOSTS.has(url.hostname))return;
  if(event.clientId)event.respondWith(cdnResponse(event));
  else writeLog(event,{kind:'cdn',...requestInfo(event),result:'no-client'});
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
