# 🌌 Witnessed Art

**AIによる画像の「進化」を、14日間かけて見守る。**
即時性を排除し、あえて時間をかけることで生まれる「愛着」と「精神的な体験」を提供するAIアートアプリ。

---

## 🎨 プロジェクト概要

`Witnessed Art` は、AIが生成したアートが14日間かけて少しずつ変化・進化していく過程を観測するモバイルアプリケーションです。ユーザーは1日1回「進める」操作を通じて、アートが日々形作られていくプロセスを共に歩みます。

> 「時間をかけて見守った」という記憶そのものを体験価値として提供します。

## ✨ 主な機能

- **⏳ AI画像エボリューション**: SDXL img2img を使用し、14段階のステップで画像が進化。
- **🔔 デイリーリマインダー**: 「絵が待っています」という詩的な通知で再訪を促す。
- **🎟️ 広告チケット**: 広告視聴により、24時間の待機時間をスキップして進行。
- **📁 コレクション保存**: 複数の進化プロセスをスロットに保存可能。
- **💎 プレミアムプラン**: 保存枠の拡張や、進化の過程をタイムラプス動画として出力。

## 🛠️ 技術スタック

### Frontend (Cross-platform)
*   **Framework**: Flutter (iOS 15.0+ / Android 8.0+)
*   **Architecture**: BLoC / Clean Architecture
*   **Services**: Firebase (Auth/FCM), Google Mobile Ads (AdMob), RevenueCat

### Backend (Cloud Native)
*   **Language**: Python 3.11+
*   **Framework**: FastAPI
*   **Database**: PostgreSQL 15+ (RDS), Redis
*   **Storage**: Amazon S3 (Signed URLs)
*   **AI Engine**: SDXL via Replicate API

---

## 📂 ディレクトリ構造

```text
.
├── frontend/          # Flutter モバイルアプリ
├── backend/           # FastAPI サーバー & AI Worker
├── docs/              # 要件定義、仕様書 (requirements-v2.md 等)
├── context/           # AI駆動開発用コンテキスト情報
├── skills/            # AIエージェント定義
└── .agent/            # サブエージェント責務定義
```

## 🚀 開発の始め方

具体的な環境構築手順については [**SETUP.md**](./SETUP.md) をご覧ください。

---

## 📚 ドキュメント

- [要件定義書 v2.0](./docs/requirements-v2.md)
- [AI駆動開発フレームワーク](./docs/ai-driven-development-framework.md)

