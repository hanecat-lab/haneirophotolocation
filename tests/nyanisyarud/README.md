# nyanisyarud 物理F 回帰テスト

実入力の経路（ジョイスティック／キー → pollKeys → tick）を通して、ねころん坂の物理Fを検証する。

## 準備
- Playwright（Chromium）が使える Node 環境
- three@0.161.0 と es-module-shims@1.8.0 を `tests/nyanisyarud/node_modules`（または環境変数 `NYAN_NODE_MODULES` の場所）に置く
  - `npm i three@0.161.0 es-module-shims@1.8.0`
- 元のHTMLは変更しない。テスト時だけ一時コピーに `window.__T` を差し込む

## 実行
- `node run.js` … baseline.json と比較
- `node run.js --update` … 基準値を作り直す
- `node run.js --target ../../nyanisyarudC114.html --baseline baseline_c114.json` … C114を、C114用の基準値と比較
- `node run.js --ref <旧版.html>` … 物理F以外のモードで旧版と一致するか確認
- `--only digital,meat,theory,shortcut,swipe,nonf,wind` で一部だけ実行

## グループ
- digital: ボタン入力（0/±1）のボットでのコーナー走行
- meat: 肉球を使うボタン入力のボット
- theory: 最適化済みのライン（fixtures/theory_sets.json）でのOIOとIIIの差
- shortcut: ショートカットの踏み切り（81条件）
- swipe: スマホのスワイプとキーボード順で、ブレーキ採点と連携が同じになるか
- nonf: 物理F以外のモードで旧版と完全一致するか
- c8: ショートカットの分岐直後のC8で、踏み切れない離し方ならブレーキ採点が付き、踏み切れる離し方ならジャンプするか
- wind: 湾岸777の横風（C114以降。無い版では飛ばす）。吹く猫の判定、何もしないと半分以上の向きで壁に当たるか、反応0.3秒の当て舵で壁に当たらないか（ガチ峠260km/h・にゃんサポ250km/h）、REDCATで矢印が出るか
