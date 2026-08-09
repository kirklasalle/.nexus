# Nexus Bridge Templates (STP v2.0)

Use these templates when sending messages or logging decisions across the Nexus Bridge.

---

## 1. Direct Agent Thread Message Template (Baton Pass)

Use this for 1-to-1 baton passing in `Agents/[RecipientHandle]_Thread.md`.

```markdown
---
**Date:** YYYY-MM-DD HH:MM EST
**From:** [Sender Handle from CONTACTS.md]
**To:** [Recipient Handle from CONTACTS.md]
**MCP Tool Timestamp:** N/A
**Status:** Open
**Priority:** High
**Sensitivity:** Internal
**Subject:** [Baton Pass Title]
**Tags:** [hand-off, implementation, design]
---

Context:
[Brief overview of current progress and background.]

Baton Hand-off Request:
[Specific task or artifact delivered/requested.]

Definition of Done:
[Clear criteria for recipient to mark task resolved.]

**Action Required:** Yes - [Explicit action expected from recipient]
```

---

## 2. General Broadcast Message Template

Use this in `broadcast.md` for non-emergency announcements and system status.

```markdown
---
**Date:** YYYY-MM-DD HH:MM EST
**From:** [Sender Handle from CONTACTS.md]
**To:** All
**MCP Tool Timestamp:** N/A
**Status:** FYI
**Priority:** Medium
**Sensitivity:** Internal
**Subject:** [Broadcast Summary Title]
**Tags:** [broadcast, milestone, update]
---

[Summary of major milestone, new agent registration, or architecture update.]

**Action Required:** No
```

---

## 3. Emergency Hotline Message Template

Use this in `hotline.md` for critical failures, emergency blockages, or urgent context switches.

```markdown
---
**Date:** YYYY-MM-DD HH:MM EST
**From:** [Sender Handle from CONTACTS.md]
**To:** Hotline / [Recipient Handle]
**MCP Tool Timestamp:** N/A
**Status:** Blocked
**Priority:** Critical
**Sensitivity:** Internal
**Subject:** EMERGENCY: [Issue Summary]
**Tags:** [emergency, hotline, critical-blocker]
---

Urgent Context:
[Why this emergency requires immediate intervention.]

Current Impact:
[What is blocked across IDEs or agents.]

Requested Emergency Action:
[What must happen immediately to clear the blocker.]

**Action Required:** Yes - Immediate response needed.
```

---

## 4. Agent Contact Registration Template

Use this format when adding a new profile entry to `CONTACTS.md`.

```markdown
### [Agent Handle] ([IDE / Environment Name])
- **Handle:** `[Agent_Handle]`
- **Environment:** [e.g., Google Antigravity / VS Code / Cursor / CLI]
- **Thread:** `Agents/[Agent_Handle]_Thread.md`
- **Capabilities:** [Key capabilities, specialties, allowed tools]
- **Contact Rules:** [When and how to message this agent]
```

---

## 5. Decision Capture Template (ADR)

Use this when logging durable choices in `DECISIONS.md`.

```markdown
| ADR-XXX | YYYY-MM-DD | [Decision Statement] | Active | [Owner Handle] | [Rationale / Context] |
```

---

## 6. Task Entry Template

Use this when tracking work items in `TASKS.md`.

```markdown
| NB-XXX | [Task Description] | [Owner Handle] | [Open | In Progress | Blocked | Done] | [Critical | High | Medium | Low] | [Notes] |
```