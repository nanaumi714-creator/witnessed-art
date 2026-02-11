# セットアップガイド (SETUP.md)

このドキュメントでは、Witnessed Art の開発環境を構築する手順を説明します。

## 前提条件

以下のツールがインストールされていることを確認してください。

- **Frontend**: Flutter SDK (>=3.2.0)
- **Backend**: Python (>=3.10)
- **Database**: Supabase (PostgreSQL)
- **Container**: Docker Desktop (Supabaseの実行に必要)

---

## 1. バックエンドのセットアップ (`backend/`)

1.  **ディレクトリへ移動**
    ```bash
    cd backend
    ```

2.  **仮想環境の作成と起動**
    ```bash
    # Windows
    python -m venv venv
    .\venv\Scripts\activate

    # macOS/Linux
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **依存関係のインストール**
    ```bash
    pip install -r requirements.txt
    ```

4.  **環境変数の設定**
    `.env` ファイルを作成し（`.env.example` があればそれをコピー）、必要な情報を設定します。
    ```bash
    # Supabase (Local)
    SQLALCHEMY_DATABASE_URI="postgresql://postgres:postgres@localhost:54332/postgres"
    POSTGRES_USER="postgres"
    POSTGRES_PASSWORD="postgres"
    POSTGRES_SERVER="localhost:54332"
    POSTGRES_DB="postgres"

    REPLICATE_API_TOKEN="your_token"
    AWS_ACCESS_KEY_ID="your_key"
    AWS_SECRET_ACCESS_KEY="your_secret"
    AWS_S3_BUCKET="witnessed-art-dev"
    ```

5.  **Supabase の起動**
    ```bash
    # プロジェクトルートで実行
    supabase start
    ```

6.  **データベースマイグレーション**
    ```bash
    # backend ディレクトリで実行
    alembic revision --autogenerate -m "Initial migration" # 初回のみ
    alembic upgrade head
    ```

7.  **サーバーの起動**
    ```bash
    uvicorn app.main:app --reload
    ```

---

## 2. フロントエンドのセットアップ (`frontend/`)

1.  **ディレクトリへ移動**
    ```bash
    cd frontend
    ```

2.  **パッケージのインストール**
    ```bash
    flutter pub get
    ```

3.  **Firebase の設定**
    - `google-services.json` (Android) および `GoogleService-Info.plist` (iOS) を適切なディレクトリ（`android/app/`, `ios/Runner/`）に配置してください。

4.  **アプリの実行**
    ```bash
    flutter run
    ```

---

## 3. トラブルシューティング

- **Flutter のエラー**: `flutter doctor` を実行して、環境に問題がないか確認してください。
- **DB接続エラー**: `DATABASE_URL` が正しいこと、およびDBサーバーが起動していることを確認してください。
- **AI生成エラー**: `REPLICATE_API_TOKEN` が有効であることを確認してください。
