// Loads a nyanisyarud build in headless Chromium with a test-only hook.
// - The CDN imports (three@0.161.0, es-module-shims@1.8.0) are served from a local
//   node_modules (NYAN_NODE_MODULES or ./node_modules) because unpkg may be blocked.
// - A copy of the page is written with `window.__T={ev}` appended to the game module,
//   so tests can read module state with direct eval. The original file is untouched.
const {chromium}=require('playwright');const fs=require('fs');const path=require('path');const os=require('os');
const NM=process.env.NYAN_NODE_MODULES||path.join(__dirname,'..','node_modules');
function probeCopy(file){
  const lines=fs.readFileSync(file,'utf8').split('\n');
  const start=lines.findIndex(l=>l.includes('<script type="module">'));
  if(start<0)throw new Error('module script not found: '+file);
  let end=start;while(end<lines.length&&!lines[end].startsWith('</script>'))end++;
  lines.splice(end,0,'window.__T={ev:(code)=>eval(code)};');
  const out=path.join(fs.mkdtempSync(path.join(os.tmpdir(),'nyan-')),path.basename(file));
  fs.writeFileSync(out,lines.join('\n'));return out;
}
async function load(file,query){
  const probe=probeCopy(file);
  const b=await chromium.launch();const p=await b.newPage({viewport:{width:900,height:600}});
  const errs=[];p.on('pageerror',e=>errs.push(String(e).slice(0,300)));
  await p.route(/^https?:\/\//,async r=>{
    const u=r.request().url();let m;
    if((m=u.match(/unpkg\.com\/three@0\.161\.0\/(.*)$/))){const f=path.join(NM,'three',m[1]);if(fs.existsSync(f))return r.fulfill({path:f,contentType:'application/javascript'});}
    if(u.includes('es-module-shims'))return r.fulfill({path:path.join(NM,'es-module-shims/dist/es-module-shims.js'),contentType:'application/javascript'});
    return r.fulfill({status:404,body:''});
  });
  await p.goto('file://'+probe+'?'+query,{waitUntil:'load',timeout:90000});
  await p.waitForFunction(()=>window.__T,null,{timeout:60000});
  return {b,p,errs};
}
module.exports={load};
