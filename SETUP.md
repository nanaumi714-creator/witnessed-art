# セットアップガイド (SETUP.md)

このドキュメントでは、Witnessed Art の開発環境を構築する手順を説明します。

## 前提条件

以下のツールがインストールされていることを確認してください。

- **Frontend**: Flutter SDK (>=3.2.0)
- **Backend**: Python (>=3.10)
- **Database**: PostgreSQL (推奨) または SQLite (ローカル開発用)

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
    DATABASE_URL="sqlite:///./sql_app.db" # または postgresql://user:pass@localhost/dbname
    REPLICATE_API_TOKEN="your_token"
    AWS_ACCESS_KEY_ID="your_key"
    AWS_SECRET_ACCESS_KEY="your_secret"
    ```

5.  **データベースマイグレーション**
    ```bash
    alembic upgrade head
    ```

6.  **サーバーの起動**
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
