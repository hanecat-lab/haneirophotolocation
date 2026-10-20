# 共通部品と診断ページ

## 方針

- 共通部品は `lib/` に置く。`lib/` を変えた時も公開されるよう、`auto-version.yml` の対象に `lib/**` を入れてある。
- 使うのは新しく作るアプリから。既存アプリ（Vlog-Studio・bokasi など）は今の実装のままにし、別の理由でそのアプリを直す時に1つずつ移す。
- 共通部品を変えると、使っている全アプリに同時に効く。変える前に、下の「使っているアプリ」を確認する。

## 部品の一覧

| ファイル | できること | 元にした実装 | 使っているアプリ |
|---|---|---|---|
| `lib/export-mp4.js` | 描いたコマを1枚ずつエンコードして MP4（音つきも可）にする | `Vlog-Studio.html`（なめらか書き出し）、`bokasi.html`（`ynFrameExport`） | なし（新しいアプリ向け） |

### lib/export-mp4.js

```js
import {createMp4Writer,probeMp4Support} from './lib/export-mp4.js';

const w=await createMp4Writer({width:1080,height:1920,fps:30,bitrate:8e6,audio:true});
if(!w.ok){
  // w.reason: no-video-encoder / module-load / no-video-codec / no-audio-encoder / no-audio-codec
  // ここで実時間の録画などに切り替える
}
for(let i=0;i<frameCount;i++){
  draw(i/30);                  // 動画の移動と描画はアプリ側
  await w.addFrame(canvas,i);  // エンコーダが詰まっている間は待つ
}
if(w.audioCodec) await w.addAudio(audioBuffer); // 48kHz の AudioBuffer。1回だけ
const {blob,stats}=await w.finish();
```

- 映像は H.264 High → Main → Baseline → VP9 の順で、端末が対応するものを使う（bokasi と同じ）。音は AAC → Opus。
- AAC は ADTS のヘッダーを外し、エンコーダが付ける description から AudioSpecificConfig を取り出す。取り出せなければ、サンプルレートとチャンネル数から作る（両アプリと同じ）。
- 部品が受け持たないこと: 動画を指定の時刻へ移動しそのコマか確かめること、画面が裏にある間に待つこと、音の読み込みと合成。これらは両アプリで中身が違うため、アプリ側に残す。
- `probeMp4Support()` は、書き出さずに使える方式だけを調べる（診断表示用）。

## 診断ページ

| ページ | 見られるもの |
|---|---|
| `sw-diag.html` | このサイトに登録された Service Worker（受け持つ範囲・状態）、保存領域の使用量、キャッシュごとの件数・合計・URLと大きさ。読むだけで、消したり変えたりはしない。「結果をコピー」で JSON をコピーできる |

### 調べたいこと（sw.js）

`index.html` と `event.html`（Event Flow）が、`sw.js` をサイト全体（`./`）を受け持つ形で登録している。`sw.js` は、同じサイトから読み込む GET をすべて `event-flow-shell-v1` に保存する。

- headless Chromium での確認: Event Flow を開いた後に、別のアプリの GLB（`nyanisyarud-tree-blue.glb`）を読み込むと、`event-flow-shell-v1` に保存されていた。
- 実機で `sw-diag.html` を開き、キャッシュに他のアプリのファイルや大きな GLB が入っていないか、使用量がどれくらいかを確かめてから、直し方を決める。
