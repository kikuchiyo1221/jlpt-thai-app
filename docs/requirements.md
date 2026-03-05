# JLPT Thai Learning App - Requirements

## Overview
Thai people向け JLPT N5-N3 日本語学習アプリ

## Target Users
- タイ人の日本語学習者
- JLPT N5 ~ N3 を目指す初級〜中級者

## Platform
- iOS & Android (Flutter)

## UI Language
- タイ語ベース + 日本語併記

## Revenue Model
- 完全無料（広告なし）

---

## Features

### MVP (Phase 1)
| Feature | Description |
|---------|-------------|
| Vocabulary | フラッシュカード形式の単語学習（N5/N4/N3レベル別） |
| Grammar | 文法解説・例文表示（タイ語訳付き） |
| Kanji | 読み・書き・意味の学習 |
| Mock Test | JLPT本番形式の選択式問題 |
| Gamification | XP・レベルアップ・ストリーク・バッジ |
| Dashboard | 学習統計ダッシュボード |

### Phase 2
| Feature | Description |
|---------|-------------|
| Reading | 長文読解練習 |
| Listening | TTS音声によるリスニング練習 |

---

## Gamification
- **XP (経験値)** - 問題正解・学習完了でXP獲得、レベルアップ
- **Streak (連続学習)** - 毎日の学習継続をカウント
- **Badges (バッジ)** - 実績達成で獲得（例：漢字マスター、文法100問クリア）

## Dashboard
- 日別学習時間グラフ
- 科目別正答率（語彙・文法・漢字・模擬テスト）
- N5 → N4 → N3 到達度（%表示）
- 苦手分野の分析・ハイライト

---

## Technical Requirements

### Framework
- Flutter (Dart)

### State Management
- Riverpod

### Local Storage
- Hive (軽量NoSQL) - ユーザー設定・進捗・キャッシュ
- SQLite (drift) - コンテンツデータの構造化保存

### Content Delivery
- REST API からコンテンツ取得
- 取得済みデータをローカルにキャッシュ（オフライン対応）

### TTS (Text-to-Speech)
- flutter_tts パッケージ（Phase 2）

### Authentication
- なし（ローカル保存のみ）

---

## Architecture

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── router/
├── features/
│   ├── vocabulary/
│   │   ├── data/        # repository, data sources
│   │   ├── domain/      # models, use cases
│   │   └── presentation/ # screens, widgets, providers
│   ├── grammar/
│   ├── kanji/
│   ├── mock_test/
│   ├── dashboard/
│   ├── gamification/
│   ├── reading/         # Phase 2
│   └── listening/       # Phase 2
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
│       ├── api_service.dart
│       ├── cache_service.dart
│       └── tts_service.dart
└── l10n/                # タイ語・日本語ローカライズ
```

## API Design (Backend)

### Endpoints
- `GET /api/v1/vocabulary?level=N5` - 語彙データ取得
- `GET /api/v1/grammar?level=N5` - 文法データ取得
- `GET /api/v1/kanji?level=N5` - 漢字データ取得
- `GET /api/v1/mock-test?level=N5` - 模擬テスト問題取得
- `GET /api/v1/reading?level=N3` - 読解問題取得（Phase 2）

### Response Format
```json
{
  "status": "success",
  "data": [...],
  "meta": {
    "level": "N5",
    "total": 100,
    "page": 1
  }
}
```
