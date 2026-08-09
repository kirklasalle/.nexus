# Nexus Certification

Use this file to sign off Nexus operational readiness for the bridge.

## Readiness Criteria
- [ ] Can orient from `STATUS.md`, `TASKS.md`, and the relevant active thread in under 10 minutes.
- [ ] Can choose the correct destination for updates: `hotline.md`, active thread, `TASKS.md`, `DECISIONS.md`, or `Shared_Assets/`.
- [ ] Can use the STP header or the templates in `TEMPLATES.md` without correction.
- [ ] Can run `tools/Validate-Bridge.ps1` and interpret a clean pass.
- [ ] Can preview rollover with `tools/New-BridgeArchive.ps1 -WhatIf`.
- [ ] Can complete the monthly review loop in `NEXUS_PLAYBOOK.md`.
- [ ] Can keep `STATUS.md` current after material bridge changes.

## Evidence Checklist
- [ ] One correct broadcast update exists in `hotline.md`.
- [ ] One correct directed request exists in an active thread.
- [ ] One task state change exists in `TASKS.md`.
- [ ] One durable operating rule exists in `DECISIONS.md`.
- [ ] One successful validator run has been recorded.
- [ ] One successful archive preview has been performed.
- [ ] One completed monthly review record exists in `Reviews/`.

## Sign-Off
- Operator: Nexus
- Reviewer: ____________________
- Date: ____________________
- Result: [ ] Ready  [ ] Not Ready
- Notes:

```
[Record any final gaps, observations, or corrective actions here.]
```