# 生成途中体験型AIアートアプリ 要件定義書 v2.0

## 文書管理情報

- 作成日: 2025-12-25
- 版数: 2.0
- ステータス: レビュー承認待ち
- 承認者: [未定]

---

## 目次

1. [プロジェクト概要](#1-プロジェクト概要)
2. [機能要件](#2-機能要件)
3. [非機能要件](#3-非機能要件)
4. [技術仕様](#4-技術仕様)
5. [データ設計](#5-データ設計)
6. [セキュリティ要件](#6-セキュリティ要件)
7. [収益モデル](#7-収益モデル)
8. [リスク管理](#8-リスク管理)
9. [開発計画](#9-開発計画)
10. [付録](#10-付録)

---

## 1. プロジェクト概要

### 1.1 製品概要

AI画像生成の「完成に至る過程」を体験価値として提供するモバイルアプリケーション。ユーザーは1日1回「進める」操作を通じて、約14日間かけて絵が形成される過程を観測する。

- **製品名**: [未定]
- **対象プラットフォーム**: iOS 15.0+ / Android 8.0+
- **開発期間**: 8週間（MVP）
- **想定初期ユーザー数**: 50人（クローズドβ）→ 500人（正式版1ヶ月後）

### 1.2 コアバリュープロポジション

| 項目 | 内容 |
|------|------|
| **提供価値** | 「時間をかけて見守った」という記憶・体験 |
| **差別化要素** | 即時性を排除し、意図的に遅延させた生成プロセス |
| **ターゲット** | デジタルデトックス志向、スローライフ実践者、瞑想・マインドフルネス層 |

### 1.3 成功指標（KPI）

| 指標 | 目標値 | 測定期間 |
|------|--------|----------|
| 7日継続率 | 30%以上 | β期間中 |
| 14日完走率 | 15%以上 | β期間中 |
| DAU/MAU比率 | 0.4以上 | 正式版1ヶ月後 |
| 課金転換率 | 5%以上 | 正式版3ヶ月後 |
| ARPU | $1.5/月 | 正式版3ヶ月後 |

---

## 2. 機能要件

### 2.1 コア機能

#### 2.1.1 画像生成進行機能

**FR-001: 初回生成**

| 項目 | 詳細 |
|------|------|
| 機能ID | FR-001 |
| 優先度 | 必須 |
| 概要 | 初回起動時に空白キャンバスから生成を開始 |
| トリガー | ユーザーが「生み出す」ボタンを押下 |
| 前提条件 | ユーザー登録完了、画像生成枠が空 |
| 処理フロー | 1. seedをランダム生成<br>2. txt2imgで初期画像生成（ノイズ状態）<br>3. step=0として保存<br>4. 画像表示 |
| 成功条件 | 初期画像がS3に保存され、UIに表示される |
| 失敗時処理 | エラー画面表示、リトライボタン提供 |
| 所要時間 | 最大30秒 |

**FR-002: 日次進行**

| 項目 | 詳細 |
|------|------|
| 機能ID | FR-002 |
| 優先度 | 必須 |
| 概要 | 前回進行から24時間経過後、画像を1ステップ進める |
| トリガー | ユーザーが「進める」ボタンを押下 |
| 前提条件 | - 前回進行から24時間以上経過<br>- または広告チケット所持 |
| 処理フロー | 1. 進行可否判定（24時間経過 or チケット消費）<br>2. Before画像を取得<br>3. img2imgで次ステップ生成<br>4. NSFWチェック<br>5. 旧画像削除、新画像保存<br>6. Before→After演出表示<br>7. step+1, last_progressed_at更新 |
| 成功条件 | 新画像が表示され、stepが更新される |
| 失敗時処理 | - 24時間未経過: 残り時間表示<br>- 生成失敗: 旧画像維持、エラー通知<br>- NSFWフィルタNG: 旧画像維持、再試行 |
| 所要時間 | 最大30秒 |

**FR-003: Before/After演出**

| 項目 | 詳細 |
|------|------|
| 機能ID | FR-003 |
| 優先度 | 必須 |
| 概要 | 進行時に変化を視覚的に提示 |
| 演出仕様 | - Before画像: 1秒間表示<br>- クロスフェード: 0.8秒<br>- After画像: 静止表示<br>- 演出中は操作不可 |
| データ保持 | Before画像は演出終了後即座に削除 |

#### 2.1.2 保存・初期化機能

**FR-004: 画像保存**

| 項目 | 詳細 |
|------|------|
| 機能ID | FR-004 |
| 優先度 | 必須 |
| 概要 | 現在の画像を保存し、新規生成を開始可能にする |
| トリガー | 「保存して新しく始める」ボタン押下 |
| 前提条件 | 保存枠に空きがある |
| 処理フロー | 1. 保存枠チェック<br>2. 現在の画像・seed・stepを保存テーブルに記録<br>3. 現在の生成状態を初期化<br>4. 確認メッセージ表示 |
| 制約 | - 無料: 1枠<br>- Patron Pack: 3枠<br>- Creator Pack: 5枠 |

**FR-005: 初期化**

| 項目 | 詳細 |
|------|------|
| 機能ID | FR-005 |
| 優先度 | 必須 |
| 概要 | 現在の生成状態を破棄し、新規生成を開始 |
| トリガー | 「初期化」ボタン長押し（3秒） |
| 確認ダイアログ | 「現在の絵は失われます。本当に初期化しますか？」 |
| 処理フロー | 1. 現在画像をS3から削除<br>2. seed/step/画像パスをリセット<br>3. 空白キャンバス表示 |

#### 2.1.3 広告チケット機能

**FR-006: 広告視聴**

| 項目 | 詳細 |
|------|------|
| 機能ID | FR-006 |
| 優先度 | 高 |
| 概要 | 動画広告視聴でチケット獲得 |
| トリガー | 「もう一度進めるには」領域をタップ |
| 広告種別 | リワード動画広告（AdMob） |
| 報酬 | チケット+1 |
| 最大所持数 | 5枚 |
| 視聴制限 | 1日最大5回まで |

### 2.2 サブ機能

#### 2.2.1 通知機能

**FR-007: プッシュ通知**

| 通知ID | タイミング | タイトル | 本文 | 優先度 |
|--------|-----------|----------|------|--------|
| NOTIF-001 | 毎日12:00（ユーザーTZ） | 「絵が待っています」 | 「今日も一歩、進めてみませんか？」 | 必須 |
| NOTIF-002 | 24時間未進行時 | 「昨日は見守れませんでしたね」 | 「今日はどんな姿になっているでしょう」 | 必須 |
| NOTIF-003 | 7日連続達成時 | 「一週間、ありがとう」 | 「絵はあなたを覚えています」 | オプション |

**実装要件**:
- Firebase Cloud Messaging使用
- 通知ON/OFF設定提供
- iOS通知許可ダイアログは2回目起動時に表示

#### 2.2.2 設定機能

**FR-008: ユーザー設定**

| 設定項目 | デフォルト値 | 説明 |
|----------|-------------|------|
| 通知ON/OFF | ON | プッシュ通知の有効化 |
| 通知時刻 | 12:00 | 日次通知の送信時刻 |
| 広告表示 | ON | 課金ユーザーはOFF固定 |

---

## 3. 非機能要件

### 3.1 パフォーマンス要件

| 項目 | 目標値 | 測定条件 |
|------|--------|----------|
| 画像生成時間 | 30秒以内 | img2img, 36 steps, SDXL |
| API応答時間 | 200ms以内 | 画像生成以外のエンドポイント |
| アプリ起動時間 | 2秒以内 | コールドスタート |
| 画像読込時間 | 1秒以内 | S3署名付きURL |

### 3.2 可用性要件

| 項目 | 目標値 |
|------|--------|
| サービス稼働率 | 99.0%（月間） |
| GPU Worker稼働率 | 98.0% |
| 計画メンテナンス | 月1回、午前3:00-4:00 |

### 3.3 拡張性要件

| 項目 | 初期値 | スケール目標 |
|------|--------|--------------|
| 同時接続数 | 50 | 1,000 |
| 日次生成数 | 100回 | 2,000回 |
| ストレージ容量 | 50GB | 500GB |

### 3.4 保守性要件

- ログ保持期間: 30日
- エラー通知: Sentry統合
- モニタリング: Datadog / Grafana
- デプロイ頻度: 週1回（バグ修正は即時）

---

## 4. 技術仕様

### 4.1 システムアーキテクチャ

```text
┌─────────────────────────────────────────────────┐
│                 Client Layer                     │
│  ┌─────────────────────────────────────────┐   │
│  │      Flutter App (iOS/Android)           │   │
│  │  - UI/UX                                 │   │
│  │  - Firebase Auth                         │   │
│  │  - AdMob                                 │   │
│  │  - RevenueCat                            │   │
│  └─────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────┘
                   │ HTTPS/REST API
┌──────────────────▼──────────────────────────────┐
│              Backend Layer (AWS)                 │
│  ┌─────────────────────────────────────────┐   │
│  │     FastAPI (ECS Fargate)               │   │
│  │  - ユーザー状態管理                      │   │
│  │  - 進行可否判定                          │   │
│  │  - ジョブ発行                            │   │
│  └──────────┬──────────────────────────────┘   │
│             │                                    │
│  ┌──────────▼──────────────────────────────┐   │
│  │   PostgreSQL (RDS)                       │   │
│  │  - ユーザーデータ                        │   │
│  │  - 保存画像メタデータ                    │   │
│  └──────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│           GPU Processing Layer                   │
│  ┌─────────────────────────────────────────┐   │
│  │   Replicate API / RunPod                 │   │
│  │  - SDXL img2img実行                      │   │
│  │  - NSFWフィルタリング                     │   │
│  └──────────┬──────────────────────────────┘   │
└─────────────┼───────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────┐
│            Storage Layer                         │
│  ┌─────────────────────────────────────────┐   │
│  │   Amazon S3                              │   │
│  │  - 現在画像保存                          │   │
│  │  - 保存済み画像                          │   │
│  └──────────────────────────────────────────┘   │
└──────────────────────────────────────────────────┘
```

### 4.2 技術スタック

#### 4.2.1 クライアント

| 技術 | バージョン | 用途 |
|------|-----------|------|
| Flutter | 3.24+ | UIフレームワーク |
| Dart | 3.5+ | 言語 |
| firebase_auth | latest | 認証 |
| firebase_messaging | latest | プッシュ通知 |
| google_mobile_ads | latest | 広告 |
| purchases_flutter | latest | 課金管理 |
| dio | latest | HTTP通信 |
| cached_network_image | latest | 画像キャッシュ |

#### 4.2.2 バックエンド

| 技術 | バージョン | 用途 |
|------|-----------|------|
| Python | 3.11+ | 言語 |
| FastAPI | 0.104+ | APIフレームワーク |
| PostgreSQL | 15+ | RDB |
| SQLAlchemy | 2.0+ | ORM |
| Alembic | latest | マイグレーション |
| boto3 | latest | AWS SDK |
| replicate | latest | GPU APIクライアント |

#### 4.2.3 インフラ

| サービス | 用途 |
|---------|------|
| AWS ECS Fargate | バックエンドホスティング |
| AWS RDS (PostgreSQL) | データベース |
| AWS S3 | 画像ストレージ |
| AWS CloudFront | CDN |
| Replicate / RunPod | GPU計算 |
| Firebase Auth | ユーザー認証 |
| Firebase Cloud Messaging | プッシュ通知 |
| Sentry | エラートラッキング |

### 4.3 AI生成パイプライン仕様

#### 4.3.1 フェーズ定義

| Phase | Step範囲 | denoise_strength | steps | CFG Scale | 状態 |
|-------|---------|------------------|-------|-----------|------|
| 0 | 1-2 | 0.95 | 12 | 4.5 | ノイズ・気配 |
| 1 | 3-5 | 0.80 | 18 | 5.0 | 形が生まれる |
| 2 | 6-9 | 0.60 | 24 | 5.5 | 絵として成立 |
| 3 | 10-14 | 0.40 | 32 | 6.0 | 安定・熟成 |
| 4+ | 15+ | 0.30 | 36 | 6.0 | 維持・微調整 |

#### 4.3.2 固定プロンプト

**ポジティブ:**

```text
abstract watercolor painting, serene landscape, gentle colors,
artistic, dreamy atmosphere, soft lighting, peaceful,
professional digital art, high quality, safe for work
```

**ネガティブ:**

```text
nude, nsfw, explicit, sexual content, violence, gore, blood,
disturbing, horror, scary, inappropriate, realistic photo,
text, watermark, signature, low quality, blurry
```

#### 4.3.3 初期画像生成

- **方式**: txt2img（Step 0のみ）
- **解像度**: 512x512
- **seed**: ランダム生成（UUID4の数値化）
- **出力**: 薄いグラデーション状態

#### 4.3.4 NSFWフィルタリング

```python
# 使用モデル: Falconsai/nsfw_image_detection
# 閾値: score > 0.7 でNG判定

if nsfw_score > 0.7:
    # 旧画像を維持
    # ユーザーに「生成を再試行します」通知
    # seed微調整(+1)して再生成
```

---

## 5. データ設計

### 5.1 ER図

```text
┌─────────────────────────────────────────────────┐
│ users                                            │
├─────────────────────────────────────────────────┤
│ PK  user_id (VARCHAR, Firebase UID)             │
│     seed (BIGINT)                                │
│     step (INT, default 0)                        │
│     current_image_path (VARCHAR)                 │
│     last_progressed_at (TIMESTAMP NULL)          │
│     max_save_slots (INT, default 1)              │
│     tickets (INT, default 0)                     │
│     timezone (VARCHAR, default 'UTC')            │
│     notification_enabled (BOOLEAN, default TRUE) │
│     notification_hour (INT, default 12)          │
│     created_at (TIMESTAMP)                       │
│     updated_at (TIMESTAMP)                       │
└─────────────────────────────────────────────────┘
                    │
                    │ 1:N
                    ▼
┌─────────────────────────────────────────────────┐
│ saved_images                                     │
├─────────────────────────────────────────────────┤
│ PK  id (UUID)                                    │
│ FK  user_id (VARCHAR)                            │
│     image_path (VARCHAR)                         │
│     seed (BIGINT)                                │
│     final_step (INT)                             │
│     saved_at (TIMESTAMP)                         │
└─────────────────────────────────────────────────┘
```

### 5.2 テーブル定義

#### 5.2.1 users テーブル

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| user_id | VARCHAR(128) | NOT NULL | - | Firebase UID（PK） |
| seed | BIGINT | NOT NULL | - | 現在の生成seed |
| step | INT | NOT NULL | 0 | 現在のステップ数 |
| current_image_path | VARCHAR(512) | NULL | - | S3パス |
| last_progressed_at | TIMESTAMP | NULL | - | 最終進行日時（UTC） |
| max_save_slots | INT | NOT NULL | 1 | 保存可能枠数 |
| tickets | INT | NOT NULL | 0 | 広告チケット残数 |
| timezone | VARCHAR(64) | NOT NULL | 'UTC' | ユーザーTZ |
| notification_enabled | BOOLEAN | NOT NULL | TRUE | 通知有効化 |
| notification_hour | INT | NOT NULL | 12 | 通知送信時刻 |
| created_at | TIMESTAMP | NOT NULL | NOW() | 登録日時 |
| updated_at | TIMESTAMP | NOT NULL | NOW() | 更新日時 |

**インデックス:**
- `idx_users_last_progressed` ON (last_progressed_at)

#### 5.2.2 saved_images テーブル

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | UUID | NOT NULL | gen_random_uuid() | PK |
| user_id | VARCHAR(128) | NOT NULL | - | FK: users.user_id |
| image_path | VARCHAR(512) | NOT NULL | - | S3パス |
| seed | BIGINT | NOT NULL | - | 復元用seed |
| final_step | INT | NOT NULL | - | 保存時のstep |
| saved_at | TIMESTAMP | NOT NULL | NOW() | 保存日時 |

**インデックス:**
- `idx_saved_images_user` ON (user_id, saved_at DESC)

**制約:**
- FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE

### 5.3 データ保持ポリシー

| データ種別 | 保持期間 | 削除タイミング |
|-----------|---------|---------------|
| 現在画像 | 無期限 | 初期化 or 保存時 |
| 保存画像 | 無期限 | ユーザーが削除 |
| 旧世代画像 | 0秒 | 新画像生成完了直後 |
| ログ | 30日 | 自動削除 |
| 退会ユーザーデータ | 0秒 | 退会処理時即削除 |

---

## 6. セキュリティ要件

### 6.1 認証・認可

| 項目 | 仕様 |
|------|------|
| 認証方式 | Firebase Authentication |
| サポートプロバイダ | - Email/Password<br>- Google<br>- Apple Sign In（iOS必須） |
| セッション管理 | Firebase ID Token（有効期限1時間、自動更新） |
| API認証 | Bearer Token（ID Token） |

### 6.2 API保護

#### 6.2.1 レート制限

| エンドポイント | 制限 | 単位 |
|---------------|------|------|
| POST /progress | 10回/日 | ユーザーID |
| POST /save | 5回/時間 | ユーザーID |
| GET /image/* | 100回/時間 | IP |
| その他 | 100回/分 | IP |

#### 6.2.2 リクエスト検証

```python
# HMAC署名による改ざん防止
import hmac
import hashlib

def verify_request(user_id: str, step: int, timestamp: int, signature: str) -> bool:
    expected = hmac.new(
        SECRET_KEY.encode(),
        f"{user_id}:{step}:{timestamp}".encode(),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected, signature)
```

**クライアント側実装:**

```dart
String generateSignature(String userId, int step) {
  final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final message = '$userId:$step:$timestamp';
  final hmac = Hmac(sha256, utf8.encode(SECRET));
  return hmac.convert(utf8.encode(message)).toString();
}
```

### 6.3 画像アクセス制御

#### 6.3.1 署名付きURL

```python
from itsdangerous import URLSafeTimedSerializer

def generate_image_url(image_path: str, user_id: str) -> str:
    serializer = URLSafeTimedSerializer(SECRET_KEY)
    token = serializer.dumps({'path': image_path, 'user': user_id})
    return f"https://api.example.com/image/{token}"

@app.get("/image/{token}")
async def serve_image(token: str):
    serializer = URLSafeTimedSerializer(SECRET_KEY)
    try:
        data = serializer.loads(token, max_age=900)  # 15分有効
        # S3から画像取得して返却
    except:
        raise HTTPException(404)
```

### 6.4 個人情報保護

| 項目 | 対応 |
|------|------|
| 収集データ | - Firebase UID<br>- 生成画像<br>- タイムゾーン<br>- 通知設定 |
| 収集しないデータ | - 氏名<br>- メールアドレス詳細（Firebase管理）<br>- 位置情報<br>- 連絡先 |
| 暗号化 | - 通信: TLS 1.3<br>- DB: RDS暗号化<br>- S3: SSE-S3 |
| プライバシーポリシー | App Store / Google Play 必須<br>→ 別途作成 |

---

## 7. 収益モデル

### 7.1 収益構造

```text
収益 = 広告収益 + 課金収益
     = (DAU × 広告視聴率 × RPM) + (課金ユーザー数 × ARPU)
```

### 7.2 価格設定

| 商品名 | 価格 | 種別 | 内容 |
|--------|------|------|------|
| **Patron Pack** | $2.99 | 買い切り | - 保存枠+2（計3個）<br>- 広告非表示<br>- 5種のseedプリセット |
| **Creator Pack** | $9.99 | 買い切り | - 保存枠+4（計5個）<br>- 専用UIスキン3種<br>- タイムラプス動画出力 |
| 高解像度版 | $1.99 | 都度課金 | 1024x1024出力 |
| 印刷データ化 | $4.99 | 都度課金 | 300dpi CMYK変換 |

### 7.3 収益試算

#### ケース1: DAU 500人（保守的）

| 項目 | 計算 | 月次 |
|------|------|------|
| 広告収益 | 500人 × 0.6視聴率 × 30日 × $0.005 RPM | $45 |
| Patron Pack | 500人 × 5%転換 × $2.99 | $75（初月） |
| Creator Pack | 500人 × 2%転換 × $9.99 | $100（初月） |
| **合計** | | **$220** |

**年間LTV:** 広告$540 + 課金$175（初年） = **$715**

#### ケース2: DAU 2,000人（楽観的）

| 項目 | 月次 |
|------|------|
| 広告収益 | $180 |
| 課金収益（初月） | $700 |
| 課金収益（定常） | $50（都度課金のみ） |
| **年間LTV** | **$2,760** |

### 7.4 損益分岐点

**固定費（月次）:**
- AWS ECS: $20
- RDS: $30
- S3: $5
- Replicate GPU: $57（DAU 1,000想定）
- その他: $20
- **合計: $132/月**

**変動費:**
- GPU: $0.057/ユーザー/月

**損益分岐DAU:** 約200人（広告RPM $0.005前提）

---

## 8. リスク管理

### 8.1 リスク一覧

| ID | リスク内容 | 影響度 | 発生確率 | 対策 |
|----|-----------|--------|---------|------|
| R-001 | App Store審査落ち（NSFW） | 高 | 中 | - 3層フィルタ実装<br>- 事前TestFlight配信<br>- 審査ガイドライン遵守 |
| R-002 | 14日継続率10%未満 | 高 | 中 | - β期間で検証<br>- 通知文言A/Bテスト<br>- ピボット判断（7日継続率20%未満で中止） |
| R-003 | GPU費用超過 | 中 | 低 | - Replicate上限設定（$200/月）<br>- アラート設定 |
| R-004 | 不正な連続生成 | 中 | 中 | - HMAC署名検証<br>- レート制限実装<br>- 異常検知アラート |
| R-005 | S3費用超過 | 低 | 低 | - Lifecycle Policy設定<br>- 月次$100上限アラート |
| R-006 | 画像生成失敗率10%超 | 高 | 低 | - 3回自動リトライ<br>- Sentry監視<br>- Replicate代替（RunPod）準備 |
| R-007 | NSFWフィルタ誤検知 | 中 | 中 | - 閾値チューニング（0.7→0.75）<br>- seed微調整で再生成 |
| R-008 | Firebase障害 | 中 | 低 | - 認証キャッシュ（1時間）<br>- Statusページ参照 |
| R-009 | 競合アプリ出現 | 中 | 低 | - 先行者利益確保<br>- コミュニティ形成 |
| R-010 | 法的問題（生成画像著作権） | 低 | 低 | - 利用規約で権利帰属明記<br>- 商用利用可能モデル使用 |

### 8.2 対応優先度マトリクス

```text
影響度
高 │ R-001 R-002  │ R-006
   │ [即対応]     │ [監視強化]
───┼──────────────┼──────────
中 │ R-004 R-007  │ R-003 R-005
   │ [計画対応]   │ R-008 R-009
───┼──────────────┼──────────
低 │ R-010        │
   │ [受容]       │
   └──────────────┴──────────
     低    中    高
        発生確率
```

### 8.3 コンティンジェンシープラン

#### R-001: App Store審査落ち対応

**Phase 1（審査前）:**

```yaml
- TestFlight配信: 10人×7日間
- NSFW出力ゼロの確認
- 審査ガイドライン5.1.1（プライバシー）準拠確認
- プライバシーポリシーURL設置
```

**Phase 2（審査落ち時）:**

```yaml
Day 1-2:
  - 却下理由の詳細確認
  - 対応可能性判断
    - 可能: 修正→再提出
    - 不可能: Plan B発動

Day 3-7 (Plan B):
  - Flutter Web版ビルド
  - Vercel/Cloudflare Pagesデプロイ
  - PWA化（インストール可能に）
  - Web Push API実装
  - Stripe決済統合
  - SNS/コミュニティで告知
```

#### R-002: 継続率低迷対応

**判断基準:**

```text
β期間中のメトリクス:
- 7日継続率 < 20% → 即座にピボット検討
- 14日継続率 < 10% → プロジェクト中止
```

**改善施策（優先順位順）:**

```yaml
1. 通知文言最適化:
   - A案: 詩的表現
   - B案: 実用的表現
   - 効果測定: 3日間

2. 報酬強化:
   - 3日連続: 特別seedプレゼント
   - 7日連続: 保存枠+1（24時間）
   - 14日達成: Creator Pack 50%オフ

3. ソーシャル要素追加:
   - 「今日進めた人」カウンター
   - 匿名ギャラリー（opt-in）
```

**ピボット候補:**

```yaml
案A: 時間短縮モデル
  - 14日→7日に変更
  - 1日2回進行可能に

案B: コンプリート要素追加
  - テーマ別seed 20種
  - コレクション機能
  - 実績システム
```

---

## 9. 開発計画

### 9.1 マイルストーン

| Phase | 期間 | 成果物 | 完了条件 |
|-------|------|--------|----------|
| **Phase 0: 準備** | Week 0 | - 技術検証<br>- デザインモックアップ | - img2img連鎖品質確認<br>- UIデザイン承認 |
| **Phase 1: MVP開発** | Week 1-6 | - 動作するアプリ<br>- バックエンドAPI | - TestFlight配信可能 |
| **Phase 2: β運用** | Week 7-8 | - 50人招待<br>- メトリクス収集 | - 7日継続率測定<br>- 重大バグゼロ |
| **Phase 3: 正式版** | Week 9-10 | - ストア申請<br>- 審査通過 | - App Store公開 |
| **Phase 4: 運用** | Week 11- | - マーケティング<br>- 機能改善 | - DAU 500達成 |

### 9.2 詳細スケジュール（Week 1-8）

#### Week 1-2: 基盤構築

| Day | 担当 | タスク | 成果物 |
|-----|------|--------|--------|
| 1-2 | Backend | FastAPI基本構造構築 | `/health`, `/auth`エンドポイント |
| 1-2 | Frontend | Flutter基本画面実装 | ログイン画面、メイン画面 |
| 3-4 | Backend | PostgreSQL設計・構築 | マイグレーションファイル |
| 3-4 | Backend | Replicate API統合 | txt2img/img2img動作確認 |
| 5-7 | Frontend | Firebase Auth統合 | Google/Apple Sign In |
| 5-7 | Backend | S3統合、署名付きURL | 画像アップロード/取得 |
| 8-10 | Backend | ユーザー状態管理API | `/user/state`, `/user/update` |
| 8-10 | Frontend | 画像表示・キャッシュ | cached_network_image |

**Week 2 終了時チェックポイント:**
- [ ] ログイン→画像表示の流れが動作
- [ ] 1枚の画像生成が成功
- [ ] データベース書き込み確認

#### Week 3-4: コア機能実装

| Day | 担当 | タスク | 成果物 |
|-----|------|--------|--------|
| 1-3 | Backend | 進行ロジック実装 | `/progress` API |
| 1-3 | Backend | 24時間制限ロジック | タイムゾーン対応 |
| 4-5 | Backend | フェーズ別パラメータ管理 | パラメータ計算関数 |
| 4-5 | Backend | NSFWフィルタ統合 | Safety Checker |
| 6-8 | Frontend | 進めるボタン実装 | タップ→API呼び出し |
| 6-8 | Frontend | Before/After演出 | クロスフェードアニメーション |
| 9-10 | Backend | 保存機能API | `/save`, `/saved-list` |
| 9-10 | Frontend | 保存UI実装 | 保存枠表示、保存ダイアログ |

**Week 4 終了時チェックポイント:**
- [ ] 連続3日間の進行が正常動作
- [ ] Before/After演出が滑らか
- [ ] 保存→新規生成の流れが動作

#### Week 5: 収益化機能

| Day | 担当 | タスク | 成果物 |
|-----|------|--------|--------|
| 1-2 | Frontend | AdMob統合 | リワード広告表示 |
| 1-2 | Backend | チケット管理API | `/ad/reward` |
| 3-4 | Frontend | RevenueCat統合 | 課金商品表示 |
| 3-4 | Backend | 課金検証webhook | `/webhook/purchase` |
| 5 | Backend | 保存枠拡張ロジック | max_save_slots更新 |

#### Week 6: 通知・設定

| Day | 担当 | タスク | 成果物 |
|-----|------|--------|--------|
| 1-2 | Frontend | FCM統合 | 通知受信確認 |
| 1-2 | Backend | 通知送信バッチ | Cloud Functions / Lambda |
| 3-4 | Frontend | 設定画面実装 | 通知ON/OFF、時刻設定 |
| 5-7 | 全体 | 統合テスト | E2Eシナリオテスト |

**Week 6 終了時チェックポイント:**
- [ ] TestFlight配信可能状態
- [ ] 全機能が結合動作
- [ ] クラッシュゼロ

#### Week 7-8: クローズドβ

| Day | 担当 | タスク | 成果物 |
|-----|------|--------|--------|
| 1 | PM | β参加者募集 | 50人確保 |
| 2 | Dev | TestFlight配信 | 招待コード送信 |
| 3-14 | PM | メトリクス観測 | - DAU推移<br>- 継続率<br>- クラッシュ率<br>- API成功率 |
| 3-14 | Dev | バグ修正 | ホットフィックス随時 |
| 15 | PM | Go/No-Go判断 | 判断会議 |

**β終了判断基準:**

```yaml
Go条件 (すべて満たす):
  - 7日継続率 ≥ 30%
  - クラッシュ率 < 1%
  - 重大バグ 0件
  - GPU費用 < $100

No-Go条件 (いずれか該当):
  - 7日継続率 < 20%
  - クラッシュ率 > 5%
  - 重大バグ 3件以上
```

### 9.3 リソース計画

#### 開発体制

| 役割 | 人数 | 稼働率 | 備考 |
|------|------|--------|------|
| PM | 1名 | 50% | 企画・進行管理 |
| Frontend Engineer | 1名 | 100% | Flutter |
| Backend Engineer | 1名 | 100% | FastAPI, AI |
| Designer | 1名 | 30% | UI/UX、アイコン |
| QA | 1名 | 50% | Week 6-8のみ |

**想定工数:** 約250人時（1.5人月×2ヶ月）

#### 開発環境

```yaml
バージョン管理: GitHub
プロジェクト管理: Linear / GitHub Projects
CI/CD: GitHub Actions
  - Flutter: ビルド→TestFlight自動配信
  - Backend: テスト→ECS自動デプロイ
デザイン: Figma
コミュニケーション: Slack
```

---

## 10. 付録

### 10.1 API仕様書

#### 10.1.1 認証

**全エンドポイント共通ヘッダー:**

```text
Authorization: Bearer <Firebase ID Token>
Content-Type: application/json
```

#### 10.1.2 エンドポイント一覧

##### POST /api/v1/user/init

**概要:** 初回ユーザー登録

**リクエスト:**

```json
{
  "timezone": "Asia/Tokyo"
}
```

**レスポンス:**

```json
{
  "user_id": "firebase_uid_123",
  "seed": 0,
  "step": 0,
  "current_image_url": null,
  "max_save_slots": 1,
  "tickets": 0
}
```

##### POST /api/v1/progress

**概要:** 画像を1ステップ進める

**リクエスト:**

```json
{
  "signature": "hmac_signature",
  "timestamp": 1703548800
}
```

**レスポンス（成功）:**

```json
{
  "status": "success",
  "before_url": "https://cdn.example.com/image/token123",
  "after_url": "https://cdn.example.com/image/token456",
  "new_step": 5,
  "ticket_used": false
}
```

**レスポンス（24時間未経過）:**

```json
{
  "status": "rate_limited",
  "message": "次回進行可能まで8時間12分",
  "next_available_at": "2025-12-26T12:00:00Z",
  "tickets_available": 0
}
```

##### POST /api/v1/save

**概要:** 現在の画像を保存

**リクエスト:**

```json
{}
```

**レスポンス:**

```json
{
  "status": "success",
  "saved_image_id": "uuid-123",
  "saved_at": "2025-12-25T15:30:00Z",
  "remaining_slots": 2
}
```

##### GET /api/v1/saved-images

**概要:** 保存画像一覧取得

**レスポンス:**

```json
{
  "images": [
    {
      "id": "uuid-123",
      "url": "https://cdn.example.com/image/token789",
      "final_step": 14,
      "saved_at": "2025-12-25T15:30:00Z"
    }
  ],
  "total": 1,
  "max_slots": 3
}
```

##### POST /api/v1/reset

**概要:** 初期化

**リクエスト:**

```json
{
  "confirmation": "I understand this is irreversible"
}
```

**レスポンス:**

```json
{
  "status": "success",
  "new_seed": 98765432,
  "step": 0
}
```

##### POST /api/v1/ad/reward

**概要:** 広告視聴報酬付与

**リクエスト:**

```json
{
  "ad_id": "admob_ad_123",
  "ad_network": "admob"
}
```

**レスポンス:**

```json
{
  "status": "success",
  "tickets": 3,
  "max_tickets": 5
}
```

##### GET /api/v1/user/state

**概要:** ユーザー状態取得

**レスポンス:**

```json
{
  "user_id": "firebase_uid_123",
  "seed": 12345678,
  "step": 7,
  "current_image_url": "https://cdn.example.com/image/token999",
  "last_progressed_at": "2025-12-24T12:00:00Z",
  "next_available_at": "2025-12-25T12:00:00Z",
  "can_progress_now": false,
  "tickets": 2,
  "max_save_slots": 3,
  "notification_enabled": true,
  "notification_hour": 12
}
```

### 10.2 エラーコード一覧

| コード | HTTP | 説明 | 対処 |
|--------|------|------|------|
| AUTH_001 | 401 | 認証トークン無効 | 再ログイン |
| AUTH_002 | 401 | トークン期限切れ | 自動更新 |
| RATE_001 | 429 | 24時間未経過 | 待機 or チケット使用 |
| RATE_002 | 429 | API呼び出し過多 | 再試行（指数バックオフ） |
| GEN_001 | 500 | 画像生成失敗 | 自動リトライ（3回） |
| GEN_002 | 500 | NSFWフィルタNG | seed微調整して再生成 |
| GEN_003 | 503 | GPU利用不可 | 15分後に再試行 |
| SAVE_001 | 400 | 保存枠上限 | 課金 or 削除促進 |
| SAVE_002 | 404 | 保存画像なし | - |
| SYS_001 | 500 | DB接続エラー | サポート連絡 |
| SYS_002 | 500 | S3エラー | 自動リトライ |

### 10.3 画面遷移図

```text
[起動]
  │
  ├─ 初回
  │   └→ [チュートリアル] → [ログイン] → [空白キャンバス]
  │                                          │
  │                                     [生み出す]
  │                                          │
  │                                      [生成中]
  │                                          │
  └─ 2回目以降                              ▼
      └→ [メイン画面] ←─────────────── [現在の絵]
            │                              │
            ├─ [進める] → [24h制限] → [チケット使用/待機]
            │     │
            │     └→ [生成中] → [Before/After] → [メイン画面]
            │
            ├─ [保存] → [保存確認] → [保存完了] → [空白キャンバス]
            │
            ├─ [初期化] → [長押し確認] → [空白キャンバス]
            │
            ├─ [保存一覧] → [サムネイル表示]
            │
            └─ [設定] → [通知ON/OFF]
                        [通知時刻]
                        [課金]
                        [利用規約]
                        [プライバシーポリシー]
```

### 10.4 UIモックアップ要件

#### メイン画面

```text
┌────────────────────────────┐
│ ☰                    [設定]│ ← ヘッダー
├────────────────────────────┤
│                            │
│    ┌──────────────┐        │
│    │              │        │
│    │  現在の絵    │        │ ← 画像表示エリア
│    │  (正方形)    │        │   (画面幅の80%)
│    │              │        │
│    └──────────────┘        │
│                            │
│   Step 7 / 無限            │ ← ステップ表示
│                            │
├────────────────────────────┤
│  ┌────────────────────┐   │
│  │    進める (24:00)   │   │ ← メインボタン
│  └────────────────────┘   │   (残り時間表示)
│                            │
│  広告を見てもう一度進める  │ ← チケット取得
│                            │
├────────────────────────────┤
│ [保存] [初期化] [保存一覧] │ ← フッターボタン
└────────────────────────────┘
```

#### 色指定

```yaml
プライマリ: #2C3E50 (ダークブルーグレー)
セカンダリ: #ECF0F1 (ライトグレー)
アクセント: #3498DB (ブルー)
背景: #FFFFFF
テキスト: #2C3E50
無効ボタン: #95A5A6
```

#### フォント

- 日本語: Noto Sans JP
- 英語: Inter
- サイズ: 見出し18sp / 本文14sp / キャプション12sp

### 10.5 用語集

| 用語 | 定義 |
|------|------|
| **Step** | 画像生成の進行段階。0から始まり、ユーザーが進めるたびに+1 |
| **Seed** | 乱数生成の初期値。同じseedと同じパラメータで同じ画像が生成される |
| **img2img** | 既存画像を入力として新しい画像を生成するAI技術 |
| **denoise_strength** | img2imgで元画像をどの程度変化させるかの強度（0.0-1.0） |
| **NSFW** | Not Safe For Work。職場や公共の場で見るのに不適切なコンテンツ |
| **チケット** | 24時間制限を回避して進行できる権利。広告視聴で獲得 |
| **保存枠** | 画像を保存できる最大数。無料1個、課金で拡張可能 |
| **Phase** | 生成の段階区分。Phase 0-3で異なるパラメータを使用 |

### 10.6 参考資料

#### 技術ドキュメント

- [Stable Diffusion SDXL Documentation](https://stability.ai/sdxl)
- [Replicate API Documentation](https://replicate.com/docs)
- [Flutter Firebase Auth Guide](https://firebase.flutter.dev/docs/auth/overview)
- [AdMob Rewarded Ads](https://developers.google.com/admob/flutter/rewarded)

#### デザイン参考

- [Material Design 3](https://m3.material.io/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- 参考アプリ: Slowly, Forest, Calm

#### 法務関連

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play Policy Center](https://play.google.com/about/developer-content-policy/)
- [GDPR Compliance Checklist](https://gdpr.eu/checklist/)

---

## 承認欄

| 役割 | 氏名 | 承認日 | 署名 |
|------|------|--------|------|
| プロジェクトオーナー | | | |
| 技術責任者 | | | |
| デザイン責任者 | | | |

---

## 改訂履歴

| 版 | 日付 | 改訂者 | 改訂内容 |
|----|------|--------|----------|
| 1.0 | 2025-12-25 | PM | 初版作成 |
| 2.0 | 2025-12-25 | PM | 技術仕様・リスク管理・開発計画追加 |
