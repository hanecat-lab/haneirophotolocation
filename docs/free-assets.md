# クレジット表記なしで使える素材サイト

## 方針

- ここに載せるのは「クレジット表記なし・商用可」で使えるものだけ。表記が要るもの、プランや規約しだいのものは下の「載せなかったもの」に分ける。
- ライセンスは素材ごとに変わることがある。取り込む前に、その素材のページでライセンス表示を確認する。
- 表記不要の素材でも、取り込んだら下の「取り込んだ素材の記録」に出どころを1行書く。あとでライセンスを確かめ直せるようにするため。
- 確認状況: 2026-11-07 時点の一般的な知識でまとめたもの。各サイトの最新の規約はまだ照合していない。

## 使えるもの

| サイト | 種類 | ライセンス | 条件・注意 |
|---|---|---|---|
| [polyhaven.com](https://polyhaven.com) | HDRI・テクスチャ・3Dモデル | CC0 | 全素材がCC0。HDRI は three.js の環境光（`RGBELoader` / `scene.environment`）に使える |
| [quaternius.com](https://quaternius.com) | ローポリ3Dモデル（リグ・アニメ付き） | CC0 | glTF/GLB で配布されているものはそのまま読み込める |
| [freesound.org](https://freesound.org) | 効果音 | **CC0 のものだけ** | 検索のライセンス絞り込みで「Creative Commons 0」を選ぶ。CC-BY・非商用（NC）のものは対象外 |
| [sketchfab.com](https://sketchfab.com) | 3Dモデル | **CC0 のものだけ** | 検索のライセンス絞り込みで「CC0 Public Domain」を選ぶ。無料モデルの多くは CC-BY（表記が必要）なので注意 |
| [pixabay.com/music](https://pixabay.com/music/) / [pixabay.com/sound-effects](https://pixabay.com/sound-effects/) | BGM・効果音 | Pixabay Content License | 表記不要・商用可・改変可。禁止事項は下の「Pixabay の禁止事項」を参照 |
| [mixamo.com](https://www.mixamo.com) | キャラの自動リグ・モーション | Adobe の規約（ロイヤリティフリー） | 表記不要・商用可。Adobe アカウントが必要。素材データ単体での再配布は不可 |
| [easings.net](https://easings.net) | イージング曲線 | ― | 使うのは `cubic-bezier(...)` の数値だけなので、そのまま CSS / JS に書いてよい |

### Pixabay の禁止事項

- 素材単体の再配布・販売：素材そのもの、またはわずかに変えただけのものを、単体で売ったり配ったりしない（Tシャツ・ポスターなどの物理製品、デジタルデータのどちらも）。
- 不適切な使用・中傷：識別できる人物を、不快・わいせつ・名誉毀損になる形で描かない。
- 誤解を招く関連付け：ブランド・ロゴ・商標・識別できる人物が写った素材を、その企業や人物が推奨しているように見せない。
- 商標登録：素材をロゴ・商標・サービス名の一部に使わない。
- このリポジトリでの注意：リポジトリは公開なので、置いた音ファイルは誰でもダウンロードできる。アプリに組み込んだ素材として置く使い方だが、「単体の配布」に見える余地はある。効果音は freesound の CC0 を優先し、見つからないときに Pixabay を使う。
- 確認元：[Pixabay ライセンス概要](https://pixabay.com/service/license-summary/)、[keywordfinder.jp](https://keywordfinder.jp/blog/pixabay/)、[tyosakuken.com](https://tyosakuken.com/pexels-pixabay-commercial-use-japan/)、[hitpaw.jp](https://www.hitpaw.jp/ecommerce-image-tips/pixabay-commercial-use.html)。2026-11-07 にユーザーが確認した要約。公式の原文との照合はまだ。

## 載せなかったもの

| サイト | 理由 |
|---|---|
| sketchfab（CC0以外）、freesound（CC0以外） | CC-BY は表記が必要、NC は非商用のみ |
| threejs.org/examples | MIT ライセンス。コードをコピーしたら著作権表示を残す必要がある |
| meshy.ai / tripo3d.ai / hyper3d.ai | AI生成の3D。無料プランの生成物の権利・公開範囲はプランと規約しだい |
| elevenlabs.io/sound-effects | AI生成の効果音。商用利用できるかはプランしだい |
| spline.design / unicorn.studio / jitter.video | 制作ツール。書き出しの条件（透かし・ロゴ表示など）はプランしだい |
| lexica.art / midlibrary.io / godly.website | 参考用。画像やサイトの見た目をそのまま使ってよいものではない |

## 取り込んだ素材の記録

| ファイル | 出どころ（URL） | ライセンス | 取り込んだ日 | 使っているアプリ |
|---|---|---|---|---|
| （まだなし） | | | | |

nyanisyarud の効果音は、次のファイル名で `nyanisyarud-sfx/` に置くと鳴る（置いていない音は和風の合成音で鳴る。`nyanisyarud.html?sfxtest=1` の試聴パネルで、合成音とファイルを鳴らし比べられる）。取り込んだら上の表に1行ずつ書く。

| ファイル名 | 鳴る場面 | 音のイメージ | 長さの目安 |
|---|---|---|---|
| `count.mp3` | カウントダウン 3・2・1 | 拍子木「カッ」 | 0.25秒以内 |
| `go.mp3` | GO | 太鼓「ドン」 | 0.7秒以内 |
| `rocket-good.mp3` | ロケットスタート GOOD | 鈴「シャン」 | 0.5秒以内 |
| `rocket-perfect.mp3` | ロケットスタート PERFECT | 鈴を2回（2回目は高く） | 0.6秒以内 |
| `flying.mp3` | フライング | 低い「ポコッ」 | 0.4秒以内 |

- 先頭の無音は削る（残すと拍より遅れて聞こえ、ロケットスタートの合わせ所がずれる）。
- 形式は mp3・モノラル。音量は `nyanisyarud.html` の `SFX` の `volume` で合わせる。
