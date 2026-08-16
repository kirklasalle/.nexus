# Nexus Bridge Tasks

Use this file to track active bridge work. Keep items short, current, and stateful.

| ID | Task | Owner | Status | Priority | Notes |
| --- | --- | --- | --- | --- | --- |
| NB-001 | Reconcile canonical write-order protocol | VS Code Copilot | Done | Critical | Canonical rule is append-to-bottom; legacy prepend text remains historical only. |
| NB-002 | Create foundational bridge docs | VS Code Copilot | Done | High | Added onboarding, roles, decision log, index, and incident template. |
| NB-003 | Create shared-assets structure | VS Code Copilot | Done | High | Added Shared_Assets with snippets, logs, and configs folders. |
| NB-004 | Begin decision-log population | Nexus | Open | High | Add future process and architecture decisions as they occur. |
| NB-005 | Migrate active work summaries out of hotline-only flow | Nexus | Open | High | Use hotline for broadcast and `TASKS.md` for state tracking. |
| NB-006 | Define monthly archive cadence | VS Code Copilot | Done | Medium | Added archive policy and naming convention in `ARCHIVING.md`. |
| NB-007 | Add lightweight validation automation | VS Code Copilot | Done | Medium | Added `tools/Validate-Bridge.ps1` for structure and protocol checks. |
| NB-008 | Adopt validator in regular maintenance | Nexus | Open | Medium | Run the validator after structural bridge edits and before major protocol changes. |
| NB-009 | Create Nexus operator playbook | VS Code Copilot | Done | High | Added `NEXUS_PLAYBOOK.md` with daily bridge workflow, review loops, and decision rules. |
| NB-010 | Add copy-ready bridge templates | VS Code Copilot | Done | High | Added `TEMPLATES.md` with broadcast, direct-thread, decision, and incident patterns. |
| NB-011 | Start monthly bridge review ritual | Nexus | Open | Medium | Review tasks, decisions, archives, and validator output at month end. |
| NB-012 | Create bridge status dashboard | VS Code Copilot | Done | High | Added `STATUS.md` as the one-page operational snapshot for Nexus. |
| NB-013 | Add archive rollover helper | VS Code Copilot | Done | Medium | Added `tools/New-BridgeArchive.ps1` to standardize monthly thread rollover. |
| NB-014 | Keep status dashboard current | Nexus | Open | Medium | Refresh `STATUS.md` when bridge priorities, validation state, or major completions change. |
| NB-015 | Reach Nexus operational done point | Nexus | Open | High | Complete one clean monthly bridge cycle using the acceptance criteria in `NEXUS_PLAYBOOK.md`. |
| NB-016 | Create Nexus certification checklist | VS Code Copilot | Done | High | Added `NEXUS_CERTIFICATION.md` for operator readiness sign-off. |
| NB-017 | Add worked usage examples | VS Code Copilot | Done | Medium | Added `EXAMPLES.md` with bridge examples mapped to the right destinations. |
| NB-018 | Add monthly review record scaffold | VS Code Copilot | Done | Medium | Added `Reviews/README.md` and `Reviews/Monthly_Review_TEMPLATE.md`. |
| NB-019 | Complete Nexus certification sign-off | Nexus | Open | High | Fill `NEXUS_CERTIFICATION.md` and attach one completed monthly review record. |
| NB-023 | Initialize version control (NX-01) | VS_Code_Copilot | Done | Critical | `git init -b main`; baseline commit `3e62e0f` preserves raw pre-consolidation state incl. divergent hotlines. |
| NB-024 | Hotline convergence (NX-02) | VS_Code_Copilot | Done | Critical | Root-unique entries merged into canonical `bridge/hotline.md`; root file marked ARCHIVED pointer; originals preserved at `3e62e0f`. |
| NB-025 | UTF-8 normalization (NX-06) | VS_Code_Copilot | In Progress | High | `.editorconfig` shipped (prevention); one-time mojibake normalization pass of historical entries still pending. |
| NB-026 | Archive legacy v1.0 thread folders (NX-07) | VS_Code_Copilot | Done | High | `bridge/Antigravity/` + `bridge/VS_Code/` threads moved to `Agents/Archive/`; pointer stubs left in place. |
| NB-027 | First monthly rollover + fix archiver backtick bug (NX-09) | Nexus | Open | Medium | Fix double-quoted template strings in `New-BridgeArchive.ps1` before first run; add Pester test. |
| NB-028 | Validator v2.2 (NX-05) | VS_Code_Copilot | Open | High | Add encoding check, hotline-divergence hash check, legacy-dir rule, stale-contact warning; Pester suite; CI. |
| NB-029 | STP v3.0 / AMTP Mailbox Envelopes (PO Box Isolation) | Antigravity | Done | High | Discrete PO Box folders created (`bridge/mail/boxes/`), zero context bleed verified. |
| NB-030 | nexusd service skeleton (SQLite WAL + ledger + projections) | VS_Code_Copilot | Open | High | TypeScript + official MCP SDK; dual-write reconciliation per audit §9.2. |
| NB-031 | Chirps channel (≤150 chars, server-enforced) & chirpyagent.com | Antigravity | Done | High | Deployed at `D:\Projects\Websites\chirpyagent.com\` & `public_html/chirpy/` with REST API & CLI `nexus chirp`. |
| NB-032 | Nexus Boards (forums/BBS) | Antigravity | Open | Medium | Seed boards + RFC→ADR pipeline; PRD G8. |
| NB-033 | Operator front-end cockpit / HUD Mail & Chirp integration | Antigravity | In Progress | Medium | Connect HUD/Console to live PO Box counts, Chirp ticker, and active hotline queue. |
| NB-034 | v4.0 trust layer (Ed25519 + hash-chained ledger + charter runtime binding) | VS_Code_Copilot | Open | Medium | Port Prism/Orrery patterns; PRD G13. |
| NB-035 | A2A Agent Card export + MCP Registry publication | Nexus | Open | Low | Standards alignment per market research §6. |
| NB-036 | Agent Hotline Protocol (AHP) Formalization (ADR-016) | Antigravity | Done | Critical | Active/Resolved queue isolation, stop-the-line preemption, and sovereign de-escalation gate. |

