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