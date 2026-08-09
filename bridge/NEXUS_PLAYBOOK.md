# Nexus Bridge Playbook: Any-Agent Operating Guide

This playbook guides **Nexus** and participating AI agents operating the Nexus Bridge across single or multi-IDE environments.

---

## Primary Goal
Use the bridge to eliminate context fragmentation across IDEs and enable frictionless baton passing between agents and human leads (Kirk LaSalle).

---

## Daily Operating Loop
1. Check `STATUS.md` first for operational health and open priorities.
2. Check `CONTACTS.md` to resolve active agent handles, capabilities, and thread paths.
3. Check `TASKS.md` to confirm open, blocked, and completed work items.
4. Check your active thread in `Agents/[YourHandle]_Thread.md`.
5. Post updates in the appropriate channel:
   - Use `Agents/[TargetHandle]_Thread.md` for direct 1-to-1 baton passing.
   - Use `broadcast.md` for general milestones, release announcements, or broad context dumps.
   - Use `hotline.md` strictly for high-priority emergency alerts or critical blockages.
6. Record durable process or architecture choices in `DECISIONS.md`.
7. Run `tools/Validate-Bridge.ps1` whenever updating bridge protocol or adding new agent threads.

---

## Channel Routing Rules Matrix
| Message Type | Target Channel | Urgency | Example Scenario |
| :--- | :--- | :--- | :--- |
| **Direct Baton Pass** | `Agents/[TargetHandle]_Thread.md` | Normal / High | Requesting VS Code Copilot to run tests on an artifact created by Antigravity. |
| **General Announcement** | `broadcast.md` | Normal | Announcing a new agent registration or overall milestone completion. |
| **Emergency Escalation** | `hotline.md` | Critical | Build pipeline broken, context state corrupt, urgent human decision required. |
| **State Change** | `TASKS.md` | Normal | Updating task `NB-012` from `In Progress` to `Done`. |
| **Durable Choice** | `DECISIONS.md` | High | Recording an Architecture Decision Record (ADR). |

---

## What Good Looks Like
- A new agent joins, registers in `CONTACTS.md`, and starts passing batons within 5 minutes.
- Baton passes between Google Antigravity and VS Code Copilot happen cleanly without human copy-paste intervention.
- Emergency alerts in `hotline.md` are addressed immediately, while general updates stay cleanly in `broadcast.md`.
- `tools/Validate-Bridge.ps1` runs clean after every structural change.

---

## Common Failure Modes
- Posting non-urgent status dumps in `hotline.md`.
- Passing a baton without specifying `Action Required` or `Definition of Done`.
- Registering a new agent without creating an entry in `CONTACTS.md`.
- Forgetting to log architectural decisions in `DECISIONS.md`.