# AI Workspace

ローカルファースト・サーバーレスの「AI時代のナレッジワークスペース」アプリ（Flutter製）。
OCR・メモアプリではなく、あらゆる情報を再利用可能な資産（`WorkspaceItem`）として抽象化して扱う。

## 設計原則

1. **資産の抽象化** — 入力・AI回答・確定版テキストをすべて `WorkspaceItem` として同格に扱う
2. **出力プロファイル駆動** — 特定AIプロバイダに依存しない。コードは `OutputProfile`（Markdown / JSON など）に依存する
3. **開発者コストゼロ（サーバーレス）** — APIキーはユーザーが自分で管理・ローカル保存。主要機能（OCR・編集・コピー）はAPIキーなしで動作する
4. **プロセスの資産化** — 操作列（OCR→整形→出力）をワークフローとして保存・再生（Phase 3以降）
5. **ナレッジグラフ対応** — `sourceItem` / `derivedItems` リンクで発生源→成果物の依存関係を追跡

## アーキテクチャ（Feature-First）

```text
lib/
├── core/
│   ├── database/     # Isar初期化・接続管理・isarProvider・デフォルトプロファイルseed
│   ├── network/      # AiClient抽象インターフェース（Phase 2でOpenRouter/Groq実装）
│   ├── theme/        # デザインシステム
│   └── utils/        # StorageService（プラットフォーム抽象）、クリップボード、テンプレート描画
└── features/
    ├── workspace/    # コア：WorkspaceItem / WorkspaceLog、OCR、Inbox・編集UI
    │   ├── application/   # OcrService（ML Kit実装 + Web用スタブ、条件付きimport）
    │   ├── data/          # IsarWorkspaceRepository
    │   ├── domain/        # モデル・リポジトリインターフェース
    │   └── presentation/  # InboxPage / ItemEditPage / WorkspaceListNotifier
    ├── ai_setting/   # AiSettingモデル（Phase 2でセキュアストレージ・接続テストUI）
    ├── profile/      # OutputProfileモデル・リポジトリ（デフォルト3種を初回seed）
    └── workflow/     # Phase 3（未実装）
```

## データモデル（Isar）

- `WorkspaceItem` — 知識の最小単位。`role`（input / aiResponse / finalized / template）、
  `content` / `rawContent`、`fileKey`（StorageService経由のファイル参照）、
  `sourceItem`（IsarLink）/ `derivedItems`（Backlink）によるナレッジグラフ
- `WorkspaceLog` — 操作の自動記録（create / edit / ocr / copy / aiInference / workflowRun）
- `AiSetting` — プロバイダIDと暗号化APIキー（Phase 2で使用）
- `OutputProfile` — 出力形式仕様（profileId / templateText / formatType）。
  コピー機能は必ずプロファイルのテンプレート（`{{title}}` / `{{content}}` / `{{rawContent}}`）を通す

## Phase 1（実装済み）

- 画像取り込み → ML Kit OCR（日本語対応・端末内処理・APIキー不要）→ 自動ログ
- テキスト直接入力 → 編集 → 保存（編集ログ自動記録）
- 出力プロファイル選択コピー（プレーン / Markdown / JSON、初回起動時にseed）
- 「確定版を作成」で `sourceItem` リンク付き派生アイテムを生成（ナレッジグラフの実証）
- 削除（アイテム＋ログ＋添付ファイルのカスケード）
- 添付画像は `StorageService` 経由で保存（モバイル: アプリドキュメント/media、Web: IndexedDB）

## 仕様書からの変更点（重要）

| 変更 | 理由 |
|---|---|
| `isar` → `isar_community` 3.3.2（フォーク） | 本家 isar 3.1.0+1 は無メンテで、generatorが現行Dart SDK（analyzer 8+）でクラッシュする。フォークはAPI完全互換 |
| `@Backlink('sourceItem')` → `@Backlink(to: 'sourceItem')` | `Backlink` のコンストラクタは名前付き引数 `to` が必須（位置引数はコンパイル不能で、generatorがクラッシュする） |
| Riverpod 2.x → 3.x（riverpod_generator 4系） | isar_community_generator 3.3 が `build` v4 を要求し、riverpod_generator 2系（build v2）と共存不可。生成プロバイダ名は `workspaceListProvider`（Notifierサフィックス除去） |
| `OcrService.extractText(File)` → `extractText(XFile)` | `dart:io` の `File` はWebでコンパイル不能。クロスプラットフォームの `XFile` に変更（モバイル実装はML Kitに `path` を渡すだけで等価） |
| **Webビルドは現状不可** | Isar 3系はWeb未サポート（`openIsar` が実行時にthrowするスタブ、かつ生成コードの64bit整数リテラルがdart2jsでコンパイルエラー）。**ファイル保存のWeb対応（IndexedDB版StorageService）は実装済み**なので、Isar v4（WASM）安定後またはデータソース差し替え（リポジトリ抽象の背後のみの変更）でWeb対応可能 |

## 開発

```bash
flutter pub get
dart run build_runner build        # モデル・プロバイダのコード生成（*.g.dart）
flutter analyze                    # 静的解析（0 issues）
flutter test                       # ユニット + Isar実DBテスト（ネイティブライブラリ同梱分を使用）
flutter run                        # Android / iOS
```

## Phase 2（次フェーズ）

- `AiSetting` のセキュアストレージ実装（flutter_secure_storage / 暗号化IndexedDB）
- `AiClient` 実装（OpenRouter / Groq）＋設定UI（キー入力・表示切替・接続テスト）
- AIテキスト整形サービス（OCR結果クリーニング）— 結果は `role: aiResponse` のアイテムとして
  `sourceItem` リンク付きで保存
