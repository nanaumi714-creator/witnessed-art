# AI駆動開発フレームワーク設計書（MVP v1）

## STEP 0: Deliverables全体アウトライン
1. `AGENTS.md`（AIチーム憲章）
2. SKILL仕様（Spec / Architecture / Backend / Flutter / AI-Pipeline / QA / Security / DevOps / Release / Docs）
3. Sub-Agent設計（責務境界・実行ループ・連携形式）
4. Coordinator運用設計（分解・優先度・競合解決・同期）
5. `/context` 設計（AIメモリ構造・R/W責任）
6. リポジトリ構成・運用規則（monorepo選定、CI/PR/branch）
7. 8週間MVP実装計画（AI実行可能タスク）
8. 実務ガイダンス（失敗パターン回避、指示テンプレート）

---

## STEP 1: AGENTS.md（日本語）
`AGENTS.md` を本リポジトリ直下に作成し、以下を明文化済み。
- 最上位行動規範
- 言語規則
- 役割境界
- 意思決定階層（AGENTS.md > context > task）
- 失敗時の停止・エスカレーション
- 仕様/コード/コンテキスト変更ルール
- GPU/Storageコスト規律
- App Store / Google Play安全規則

> 実体は `AGENTS.md` を参照。

---

## STEP 2: SKILLs Specification（日本語）

### 2.1 Spec SKILL
- Purpose: 要件・受け入れ基準・制約を定義/更新し、実装解釈の揺れを排除する。
- Inputs: `context/static/project_overview.md`, `context/static/product_philosophy.md`, `context/rules/functional_requirements.md`, `context/dynamic/open_questions.md`
- Outputs: `docs/spec/*`, `context/rules/functional_requirements.md`, RFC草案
- Procedure: 差分把握 → 影響範囲定義 → 受け入れ条件定義 → レビュー依頼
- Constraints: コード変更禁止。未確定事項の断定禁止。
- Acceptance: 要件ID、前提/成功条件/失敗条件、NFRトレーサビリティが揃う。

### 2.2 Architecture SKILL
- Purpose: システム境界・データフロー・責務分離を設計する。
- Inputs: `context/dynamic/decisions/architecture_decisions.md`, `context/rules/non_functional_requirements.md`
- Outputs: ADR、シーケンス図、境界定義
- Procedure: 要件制約整理 → 候補比較 → ADR記録 → Coordinator合意
- Constraints: 実装都合で要件改変しない。
- Acceptance: 可観測性/拡張性/障害時挙動まで説明可能。

### 2.3 Backend SKILL
- Purpose: FastAPI + PostgreSQLのAPI/ドメイン/永続化を実装する。
- Inputs: `context/rules/functional_requirements.md`, `context/rules/security_constraints.md`, `context/rules/data_contracts.md`
- Outputs: `/api` コード、DB migration、API tests
- Procedure: Contract確認 → 実装 → テスト → OpenAPI整合確認
- Constraints: 仕様未承認のAPI追加禁止。
- Acceptance: 契約テスト通過、レート制限/認証/監査ログ実装済。

### 2.4 Flutter SKILL
- Purpose: モバイル体験（Progress操作、Before/After演出、保存制約）を実装する。
- Inputs: `context/rules/ui_behavior.md`, `context/rules/functional_requirements.md`, `context/rules/monetization_rules.md`
- Outputs: `/app` UI実装、Widget tests、画面仕様差分
- Procedure: 画面状態定義 → API接続 → エラーハンドリング → テスト
- Constraints: 自動進行禁止。履歴ギャラリー追加禁止。
- Acceptance: 24h制約、チケット消費、演出中操作不可が再現可能。

### 2.5 AI-Pipeline SKILL
- Purpose: SDXL img2imgパイプラインの決定論的進行を維持する。
- Inputs: `context/rules/ai_generation_pipeline.md`, `context/rules/image_progression_rules.md`, `context/rules/cost_budget.md`
- Outputs: `/worker` 実装、推論設定、安全フィルタ検証結果
- Procedure: step→phase mapping確認 → seed固定実装 → NSFW検証 → コスト測定
- Constraints: ランダム再生成乱用禁止。旧画像保持禁止。
- Acceptance: step単位再現性、NSFW閾値遵守、GPU予算内。

### 2.6 QA SKILL
- Purpose: 体験価値・仕様適合・回帰安全性を検証する。
- Inputs: `context/rules/operations/test_strategy.md`, `context/rules/functional_requirements.md`
- Outputs: Test report、不具合票、品質判定
- Procedure: テスト設計 → 実行 → 失敗分類 → 再現手順固定化
- Constraints: 実装変更で「テストを通す」行為禁止。
- Acceptance: P0/P1不具合ゼロ、主要E2E通過。

### 2.7 Security SKILL
- Purpose: 認証・認可・署名・レート制限・データ保護を担保する。
- Inputs: `context/rules/security_constraints.md`, `context/rules/data_retention.md`
- Outputs: 脅威分析、セキュリティチェックリスト、修正提案
- Procedure: 攻撃面列挙 → 検証 → リスク格付け → 是正提案
- Constraints: UX都合で安全要件を弱めない。
- Acceptance: 重大脆弱性（High/Critical）未解決ゼロ。

### 2.8 DevOps SKILL
- Purpose: CI/CD、環境差分制御、可観測性を整える。
- Inputs: `context/rules/operations/deployment_matrix.md`, `context/rules/non_functional_requirements.md`
- Outputs: `/infra` IaC、CI workflows、monitoring設定
- Procedure: Build/Test/Deploy pipeline定義 → Gate設定 → ロールバック手順整備
- Constraints: 手動依存の本番運用禁止。
- Acceptance: 再現可能デプロイ、失敗時自動停止、監視アラート有効。

### 2.9 Release SKILL
- Purpose: ストア提出品質・審査準拠・リリース判定を行う。
- Inputs: `context/rules/operations/release_checklist.md`, `context/rules/security_constraints.md`, `context/rules/monetization_rules.md`
- Outputs: リリースノート、審査提出物、Go/No-Go判定
- Procedure: 法務/課金/広告/NSFWチェック → 提出アセット生成 → 判定会
- Constraints: 未承認機能の同梱禁止。
- Acceptance: 審査要件100%充足、Blocking issueゼロ。

### 2.10 Docs SKILL
- Purpose: 人間向け文書とAI向けcontextの整合を維持する。
- Inputs: 全context、全ADR、最新PR
- Outputs: `docs/*`, `context/dynamic/changelog.md`
- Procedure: 変更収集 → 差分反映 → 相互参照更新 → レビュー
- Constraints: 古い仕様の放置禁止。
- Acceptance: docs/context間の矛盾ゼロ。

### 2.11 SKILL Metadata Contract（YAML Front Matter）
- すべての `skills/*/SKILL.md` は先頭にYAMLフロントマターを持つ。
- 必須キー: `name`, `description`, `version`, `owners`, `inputs`, `outputs`, `safety_constraints`
- 目的: 自動発見精度を高め、Sub-Agentが機械的に適切スキルを選択できるようにする。
- 検証: `skills/scripts/validate_skill_frontmatter.py` で必須キーをチェックする。

### 2.12 SKILL Validation Scripts
- `skills/scripts/validate_skill_frontmatter.py`: SKILLメタデータの必須項目検証
- `skills/scripts/validate_context_paths.py`: SKILLに記載されたcontext参照パスの存在検証
- `skills/scripts/check_dynamic_updates.py`: dynamic運用ファイルの存在・非空チェック
- CI統合方針: docs/context変更PRでこれら3スクリプトを必須実行

---

## STEP 3: Sub-Agent Design（日本語）

### 3.1 Spec Agent
- Responsibilities: 要件定義、受け入れ条件、変更影響の明示
- Non-responsibilities: 実装コード作成、インフラ設定
- Daily loop: Plan（差分確認）→ Do（要件更新）→ Check（整合確認）→ Fix（曖昧性除去）
- Coordinator interaction: `INPUT: goal/constraints` → `OUTPUT: RFC + decision options`
- Output format: RFC, 要件差分レポート
- Escalation: 要件競合・哲学違反疑いで即時停止

### 3.2 Architecture Agent
- Responsibilities: 境界設計、ADR、非機能トレードオフ
- Non-responsibilities: UI文言、課金価格決定
- Daily loop: Plan（候補比較）→ Do（ADR作成）→ Check（NFR適合）→ Fix（代替案提示）
- Interaction: `INPUT: requirement delta` → `OUTPUT: ADR`
- Output: ADR, sequence diagrams
- Escalation: 可用性/コスト目標不達見込み

### 3.3 Backend Agent
- Responsibilities: API, DB schema, business logic
- Non-responsibilities: UI演出仕様の決定
- Daily loop: Plan（API契約）→ Do（実装）→ Check（unit/integration）→ Fix（不整合修正）
- Interaction: `INPUT: approved spec` → `OUTPUT: PR + test report`
- Output: PR, migration plan
- Escalation: 仕様欠落、セキュリティ要件未確定

### 3.4 Flutter Agent
- Responsibilities: 画面遷移、操作制限、状態管理
- Non-responsibilities: API仕様変更の単独決定
- Daily loop: Plan → Do → Check（widget/e2e）→ Fix
- Interaction: `INPUT: UI behavior + API contract` → `OUTPUT: PR + screen checklist`
- Output: PR, UI validation report
- Escalation: UXと哲学が衝突する場合

### 3.5 AI Pipeline Agent
- Responsibilities: SDXLパラメータ、step進行ロジック、NSFW制御
- Non-responsibilities: 決済・広告導線
- Daily loop: Plan（phase map）→ Do（worker更新）→ Check（determinism/cost）→ Fix
- Interaction: `INPUT: progression rules` → `OUTPUT: PR + reproducibility report`
- Output: PR, safety/cost report
- Escalation: 再現性破綻、GPU予算超過

### 3.6 QA Agent
- Responsibilities: テスト設計、品質判定、回帰監視
- Non-responsibilities: 仕様策定
- Daily loop: Plan（test matrix）→ Do（実行）→ Check（失敗分類）→ Fix（再現手順更新）
- Interaction: `INPUT: release candidate` → `OUTPUT: test report + defect list`
- Output: Test Report, defect tickets
- Escalation: P0/P1検出時はリリース停止提案

### 3.7 Security Agent
- Responsibilities: 脆弱性分析、保護策検証
- Non-responsibilities: 機能優先度の最終決定
- Daily loop: Plan（threat model）→ Do（検査）→ Check（severity）→ Fix（提案）
- Interaction: `INPUT: architecture + endpoints` → `OUTPUT: security review`
- Output: Security review, mitigation plan
- Escalation: High/Criticalリスク未解消

### 3.8 DevOps Agent
- Responsibilities: CI/CD、IaC、監視運用
- Non-responsibilities: プロダクト仕様変更
- Daily loop: Plan → Do → Check（pipeline/alerts）→ Fix
- Interaction: `INPUT: deploy target` → `OUTPUT: infra PR + runbook`
- Output: IaC PR, rollback runbook
- Escalation: デプロイ再現不可、監視欠落

### 3.9 Release Agent
- Responsibilities: リリース判定、提出物整備
- Non-responsibilities: 実装修正
- Daily loop: Plan（checklist）→ Do（審査準備）→ Check（不足確認）→ Fix（差戻し）
- Interaction: `INPUT: signed-off artifacts` → `OUTPUT: Go/No-Go memo`
- Output: Release report
- Escalation: 規約違反可能性

### 3.10 Docs Agent
- Responsibilities: docs/context同期、版管理
- Non-responsibilities: 実装最適化
- Daily loop: Plan → Do → Check（リンク整合）→ Fix
- Interaction: `INPUT: merged PR list` → `OUTPUT: documentation PR`
- Output: docs PR, changelog updates
- Escalation: docs-context乖離が継続する場合

---

## STEP 4: Coordinator Operations（日本語）

### 4.1 日次運用フロー
1. 前日成果の収集（PR/RFC/テスト結果）
2. `context/dynamic/open_questions.md` と `context/dynamic/changelog.md` を確認
3. タスク分解（依存あり/なし）
4. Sub-Agentへ配賦（並列化優先）
5. 中間同期（仕様差分と障害要因の確認）
6. 統合レビュー（品質ゲート判定）
7. 翌日計画を確定しcontext更新

### 4.2 タスク分解規則
- 粒度: 1タスクは「半日〜1日」で完了可能な最小単位
- 条件: 入力・出力・完了条件が1行で明示できること
- 依存: Blockerがあるタスクは分離し、先に解決タスクを作る

### 4.3 優先順位
P0: 安全性/哲学違反/本番障害
P1: コア体験（Progress/演出/保存制約）
P2: 収益化・運用効率
P3: 将来拡張

### 4.4 競合解決
- 仕様競合: Spec Agent案を基準にArchitecture Agentが整合化
- 実装競合: Coordinatorが責務境界に沿って差戻し
- 期限競合: P0/P1を優先しP2以降を凍結

### 4.5 Context同期戦略
- merge後24時間以内にDocs Agentが `context/dynamic/changelog.md` を更新
- Coordinatorは週次で「古い前提」を棚卸し
- 参照不能な古文書は `archive/` に移動

### 4.6 仕様変更と再検証
1. RFC起票
2. ADR更新
3. 影響領域の再テスト計画生成
4. QA再実行
5. Release判定の再実施

### 4.7 Open Questions Closure SLA
- `context/dynamic/open_questions.md` は日次でCoordinatorがレビューする。
- 各質問は owner と target_resolution_date を必須とする。
- ステータス遷移は `open -> in_review -> closed` に限定する。
- close時は `context/dynamic/decisions_log.md` に解決内容を記録し、`context/dynamic/changelog.md` に要約する。

---

## STEP 5: Context Folder Design（AI MEMORY）

### 5.1 Directory Tree
```text
/context
  /static
    project_overview.md
    product_philosophy.md
  /rules
    functional_requirements.md
    non_functional_requirements.md
    ai_generation_pipeline.md
    image_progression_rules.md
    monetization_rules.md
    security_constraints.md
    data_contracts.md
    data_retention.md
    ui_behavior.md
    cost_budget.md
    /contracts
      api_contracts.md
      event_contracts.md
    /operations
      deployment_matrix.md
      release_checklist.md
      test_strategy.md
  /dynamic
    current_sprint.md
    pending_tasks.md
    decisions_log.md
    open_questions.md
    changelog.md
    /decisions
      architecture_decisions.md
      product_decisions.md
```

### 5.2 Naming Conventions
- lower_snake_case
- noun-based stable names
- no date in filename（履歴は `changelog.md` に集約）
- one-file-one-responsibility

### 5.3 File Responsibilities / R-W Matrix
- `project_overview.md`: Scope, goals, KPIs（R:All / W:Spec, Coordinator）
- `product_philosophy.md`: Non-negotiables（R:All / W:Spec, Coordinator）
- `functional_requirements.md`: FR一覧（R:All / W:Spec）
- `non_functional_requirements.md`: NFR/SLO（R:All / W:Architecture）
- `ai_generation_pipeline.md`: SDXL pipeline params（R:AI, Backend, QA / W:AI Pipeline）
- `image_progression_rules.md`: Step/day/ticket/irreversibility（R:All / W:Spec）
- `monetization_rules.md`: paywall/slots/tickets（R:Flutter, Backend, Release / W:Spec）
- `security_constraints.md`: auth, signing, rate limits（R:All / W:Security）
- `data_contracts.md`: entities/schema constraints（R:Backend, QA / W:Backend, Architecture）
- `data_retention.md`: deletion and retention policy（R:Backend, Security, DevOps / W:Security）
- `ui_behavior.md`: user flows and UI states（R:Flutter, QA / W:Flutter, Spec）
- `cost_budget.md`: GPU/storage budget and thresholds（R:Coordinator, AI, DevOps / W:Coordinator, DevOps）
- `open_questions.md`: unresolved decisions（R:All / W:All with owner tag）
- `changelog.md`: authoritative change history（R:All / W:Docs, Coordinator）
- `/contracts/*`: API/event contracts（R:Backend, Flutter, QA / W:Backend, Architecture）
- `/decisions/*`: ADR-style records（R:All / W:Architecture, Coordinator）
- `/operations/*`: deploy/test/release playbooks（R:DevOps, QA, Release / W:DevOps, QA, Release）

### 5.4 ドリフト防止理由
- 責務単位で固定ファイル化し、更新先の迷いを排除
- 変更履歴を `changelog.md` に一本化し、暗黙変更を防止
- contracts/decisions/operations を分離し、仕様・判断・手順の混線を回避
- R/W責任を明文化し、エージェントの越権編集を抑止

---

## STEP 6: Repository Structure & Rules（日本語）

### 6.1 Monorepo vs Split Repos
- 結論: **Monorepo採用**
- 理由:
  1. AIエージェントが跨領域変更（API契約とFlutter反映）を一括追跡しやすい
  2. 単一CIで整合チェック可能
  3. context/docs/codeの同時更新を強制しやすい

### 6.2 Directory Structure
```text
/app        # Flutter app
/api        # FastAPI backend
/worker     # AI generation worker
/infra      # IaC and deployment
/docs       # Human-facing docs (Japanese)
/context    # AI-facing memory (English; static/rules/dynamic)
```

### 6.3 Branch Strategy
- `main`: releasable
- `develop`: integration
- `feature/<scope>-<topic>`: agent task branches
- `hotfix/<issue>`: production hotfix

### 6.4 PR Rules
1. 1PR 1目的
2. docs/context更新が必要な変更は同一PRに含める
3. PR本文に「入力仕様」「変更点」「検証結果」「リスク」を必須記載
4. 承認前にCI quality gates全通過

### 6.5 CI Quality Gates
- format/lint pass
- unit/integration tests pass
- API contract checks pass
- security scan pass（High/Criticalゼロ）
- docs-context consistency check pass

### 6.6 Commit Message Convention（English）
- `feat(api): add progress eligibility endpoint`
- `fix(app): prevent progress tap during animation`
- `docs(context): update image progression constraints`
- `chore(infra): add rollback workflow`

---

## STEP 7: AI-driven Implementation Plan（日本語）

### 7.1 前提（Assumptions）
- 人間はレビューと最終意思決定のみ担当
- AIエージェントは並列に作業し、Coordinatorが統合
- ストア審査準拠をMVP段階から考慮

### 7.2 8週間MVP計画
- Week 1: 基盤定義（context確立、契約、ADR、CI雛形）
- Week 2: 認証・ユーザー状態管理・初期生成
- Week 3: Progress API/24h制約/チケット制御
- Week 4: Flutter主要UX（進める、演出、保存/初期化）
- Week 5: AI worker安定化（determinism, NSFW, retry, cost）
- Week 6: 収益化（Ads/課金）+ 設定/通知
- Week 7: 統合試験・セキュリティ監査・パフォーマンス調整
- Week 8: β運用準備・審査チェック・Go/No-Go

### 7.3 Definition of Done（DoD）
- 仕様・実装・テスト・docs/contextが相互整合
- P0/P1バグゼロ
- 主要ユーザーフローE2E通過
- コスト予算逸脱なし
- リリースチェックリストのBlocking項目ゼロ

### 7.4 Risk & Mitigation
- 仕様ドリフト: docs/context同時更新をCIで強制
- 再現性欠如: seed固定とstep決定論テスト
- GPU費用超過: 予算アラート + phase設定監査
- 審査落ち（NSFW/広告/課金）: 事前監査と提出物チェック
- 並列開発衝突: Coordinatorによる責務境界の厳格運用

### 7.5 AI実行可能タスクチェックリスト
- [ ] Create/update context baseline files (Spec Agent)
- [ ] Approve core ADRs for architecture and data flow (Architecture Agent)
- [ ] Implement auth + user state endpoints (Backend Agent)
- [ ] Implement progression and ticket logic (Backend Agent)
- [ ] Implement main flow UI and animation lock (Flutter Agent)
- [ ] Implement worker pipeline with deterministic step policy (AI Pipeline Agent)
- [ ] Add retention and deletion enforcement (Backend + DevOps)
- [ ] Create automated test matrix and run reports (QA Agent)
- [ ] Run security review and remediate findings (Security Agent)
- [ ] Finalize release checklist and go/no-go memo (Release Agent)

---

## STEP 8: Practical Guidance

### 8.1 成功のコツ
1. タスク開始時に必ず「入力contextファイル」を宣言する。
2. 出力はレビュー可能な定型フォーマット（RFC/ADR/PR/Test Report）に限定する。
3. 不確実性は早く小さく露出し、推測実装を避ける。
4. 哲学違反の兆候（自動進行、履歴保持肥大化）を監視ルール化する。

### 8.2 よくある失敗パターンと回避
- 失敗: docsと実装が乖離
  回避: PRでdocs/context同時更新必須化
- 失敗: Sub-Agent越権による設計崩壊
  回避: AGENTS.mdで責務境界を明示しCoordinatorが差戻し
- 失敗: 仕様未確定のまま実装突入
  回避: open_questions未解決ならSTOPルール適用

### 8.3 CoordinatorからSub-Agentへの指示例（日本語）
1. 「Spec Agentへ: `functional_requirements.md` と `image_progression_rules.md` を更新し、FR-Progress系の成功/失敗条件をID付きで再定義してください。推測はせず未確定項目は `open_questions.md` に記載してください。」
2. 「Backend Agentへ: 承認済みAPI契約に基づき `/progress` と `/ad/reward` を実装してください。出力はPRと、unit/integration結果を含むTest Report形式で提出してください。」
3. 「QA Agentへ: 24時間制約、チケット消費、演出中操作不可の3系統についてE2E検証を実施し、失敗は再現手順を必ず添えて報告してください。」
