# ドキュメント一覧

このディレクトリは、プロダクト仕様・要件定義・AI運用設計ドキュメントを管理します。

## 収録文書

- [`requirements-v2.md`](./requirements-v2.md): 生成途中体験型AIアートアプリ 要件定義書 v2.0
- [`ai-driven-development-framework.md`](./ai-driven-development-framework.md): AI駆動開発体制（AGENTS/SKILL/Sub-Agent/Coordinator/context/運用）

## 更新方針

- 実装前の検討事項（要件、制約、KPI、リスク）を先に更新する。
- 仕様の変更時は、文書の版数と改訂履歴を必ず更新する。
- API仕様とデータ設計の変更は、同一PR内で整合性を確認する。
- AI運用ルール変更時は `AGENTS.md` と `/context` を同時更新する。

## AI運用構成（追加）

- ルート `AGENTS.md`: AI実行規約（最上位）
- `skills/`: タスク実行方法（HOW、英語）
- `context/static|rules|dynamic`: 事実・仕様・運用状態（英語）
- `.agent/`: サブエージェント責務カード（英語）
