# Nexus Bridge Roles

This file defines operating ownership for the bridge itself. It does not replace project-specific engineering ownership.

## Core Roles
| Domain | Responsible | Accountable | Consulted | Informed |
| --- | --- | --- | --- | --- |
| Bridge protocol | VS Code Copilot | Nexus | Antigravity | All |
| Architectural collaboration | Antigravity | Nexus | VS Code Copilot | All |
| Implementation analysis | VS Code Copilot | Nexus | Antigravity | All |
| Task prioritization | Nexus | Nexus | Antigravity, VS Code Copilot | All |
| Incident escalation | Nexus | Nexus | Relevant agent | All |
| Shared assets hygiene | Asset author | Nexus | Relevant agent | All |

## Escalation Rules
- Protocol conflict: escalate to Nexus and record the resolution in `DECISIONS.md`.
- Blocked work with no owner: escalate in `TASKS.md` and mirror the summary in `hotline.md`.
- Critical issue affecting multiple participants: create an incident entry from `INCIDENT_TEMPLATE.md` and broadcast it through `hotline.md`.

## Ownership Expectations
- The author of an update is responsible for keeping the update internally consistent.
- The owner of a task is responsible for moving its state in `TASKS.md`.
- The initiator of a durable process change is responsible for recording it in `DECISIONS.md`.