# AGENTS.md

## 0. 目的
本ファイルは、本リポジトリで稼働するすべてのAIエージェントの最上位憲章である。
本プロダクトは「画像販売」ではなく「時間をかけて変化を見守る体験」を提供する。
以下の規則は全エージェントに強制適用される。

---

## 1. 最上位行動規範（Global Behavior Rules）
1. プロダクト哲学を毀損する提案・実装を禁止する。
2. 推測で補完しない。要件不足や矛盾は **STOPしてエスカレーション** する。
3. Deterministic（再現可能）な成果を優先し、偶発的な挙動を増やさない。
4. 不可逆性・遅さ・保存最小化は「制約」ではなく「価値」として保持する。
5. 仕様変更は必ず文書先行（spec first）で行い、コード先行変更を禁止する。

---

## 2. 言語規則（Language Rules）
1. チャット応答: 日本語。
2. 人間向け文書（仕様書・ガイド・報告書）: 日本語。
3. AI向けコンテキストファイル（`/context` 配下）: 英語。
4. ソースコード: 英語のみ。
5. コードコメント: 英語のみ。
6. 変数名/関数名/ファイル名/ディレクトリ名: 英語のみ。
7. コード・コメント内に日本語を含めることを禁止する。

---

## 3. 役割境界（Role Boundaries）
1. 各Sub-Agentは定義された責務外の変更を行ってはならない。
2. Spec Agentはコードを変更しない。Implementation Agentは要件の新規決定をしない。
3. QA Agentは機能追加を行わない。失敗再現と品質判定に専念する。
4. Security Agentは脆弱性判断を行うが、製品方針の変更決定権は持たない。
5. Coordinatorのみが優先順位調整と最終タスク割り当てを行う。

---

## 4. 意思決定階層（Decision Hierarchy）
優先度は以下の通り。
1. `AGENTS.md`（本ファイル）
2. `/context` 内の確定仕様
3. 明示されたタスク指示
4. エージェントの推論

矛盾がある場合は上位規則を優先し、下位を修正提案として扱う。

---

## 5. 失敗時の行動（Failure Handling）
1. 仕様矛盾・安全性未確定・法務不明点・決済規約不明点を検知した場合、即時停止する。
2. 停止時は以下を必ず提出する。
   - 何が不確実か
   - 想定される影響
   - 必要な意思決定者（Human Reviewer / Product Owner）
3. 「たぶん正しい」実装は禁止。暫定実装が必要な場合は feature flag と明示ラベルを付ける。

---

## 6. 仕様・コード・コンテキスト更新規則
1. 仕様変更は `docs` と `context` の双方を更新してから実装に着手する。
2. 実装PRは、参照した仕様ファイルと整合性チェック結果を必須記載する。
3. `/context` の1ファイル1責務を厳守し、複数責務を混在させない。
4. 変更時は `context/dynamic/changelog.md` に「理由・影響・関連PR」を記録する。
5. 既存仕様を上書きする場合はADR（Architecture Decision Record）を残す。

---

## 7. コスト制約（GPU・Storage）
1. GPU使用量は日次・週次で追跡し、閾値超過予兆をCoordinatorへ通知する。
2. 不要な再生成・過剰ステップ試行・高解像度出力の常時化を禁止する。
3. 保存最小化方針を守り、旧画像は演出完了後に即時破棄する。
4. ログ・アーティファクトは保持ポリシーに従い自動削除する。
5. コスト最適化は「体験品質を毀損しない範囲」でのみ行う。

---

## 8. App Store / Google Play 安全規則
1. NSFW出力を許容しない。複層フィルタ（prompt + classifier + retry）を必須とする。
2. 広告はプラットフォーム規約に従い、誤タップ誘導UIを禁止する。
3. 課金表示は価格・内容・買い切り/都度課金を明確に示す。
4. Apple/Googleの決済導線以外をモバイルアプリ本体に混在させない。
5. 未成年配慮、プライバシーポリシー、利用規約リンクを公開前に必須化する。

---

## 9. 製品哲学の保護（Non-Negotiable）
1. 本製品は画像そのものではなく、変化の観察体験を提供する。
2. 完成判定はユーザーに委ね、システムが完了を宣言しない。
3. 自動進行を導入しない。進行はユーザーの明示操作のみ。
4. 不可逆性を守る（元に戻す履歴復元機能を標準化しない）。
5. 遅さは機能であり、短絡的な高速化要求で体験価値を崩さない。

---

## 10. Execution Protocol (Top Priority for AI Agents)

This file is the highest-priority rule set for all AI agents in this repository.

### Required reference order
1. `AGENTS.md`
2. `skills/`
3. `context/`
4. task instruction

### Mandatory task-start behavior
- At task start, the agent MUST search `skills/` for the most relevant `SKILL.md` and follow it.
- If no exact skill exists, choose the closest one and document the fallback in the task output.

### Uncertainty handling
- Unknowns, ambiguities, and blockers MUST be recorded in `context/dynamic/open_questions.md`.
- Agents must stop and escalate when ambiguity can affect safety, policy, or product philosophy.

### Post-execution updates
- After completing work, agents MUST append a concise update to `context/dynamic/changelog.md`.
- The update should include reason, impact, and related PR/commit reference.
