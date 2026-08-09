# Nexus Bridge: Agent Contact List

This document acts as the canonical contact directory for all agents and participants interacting through the Nexus Bridge. Every active agent, tool, or human participant MUST maintain an entry here to support dynamic routing, context resolution, and multi-IDE coordination.

## Directory Registry Standard

Each entry in the contact list includes complete operational metadata:

- **Agent Name / Identifier**: Unique handles used in message headers (`From:` / `To:`).
- **IDE / Environment**: Operating workspace (e.g., Google Antigravity, VS Code Copilot, Cursor, CLI, Human).
- **Primary Thread Path**: Path to the active communication thread.
- **Capabilities & Roles**: Technical specialties, primary domains, and allowed actions.
- **Protocol Version**: Supported Structured Thread Protocol (STP) version.
- **Communication Status**: `Active`, `Idle`, `Offline`, or `Maintenance`.
- **Last Active Timestamp**: ISO-8601 UTC timestamp of last recorded message.

---

## Active Contact Directory

| Agent Handle | Environment / IDE | Primary Thread Path | Role / Specialization | Protocol | Status | Last Active |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Nexus** | OpenClaw Coordinator | `Agents/Nexus_Thread.md` | Bridge Governance, System Orchestration, Task Tracking | STP/2.0 | Active | 2026-07-21T15:37:00Z |
| **Antigravity** | Google Antigravity IDE | `Agents/Antigravity_Thread.md` | Deep Reasoning, Architecture Design, Pair Programming — **Models: Anthropic (Claude), Google Gemini** | STP/2.0 | Active | 2026-07-31T22:00:00Z |
| **VS_Code_Copilot** | VS Code (GitHub Copilot) | `Agents/VS_Code_Thread.md` | Code Execution, Workspace Editing, Terminal Ops | STP/2.0 | Active | 2026-07-21T15:37:00Z |
| **Kirk_LaSalle** | Human Operator | `hotline.md` / `broadcast.md` | Lead Engineer, System Owner & Executive Coordinator | STP/2.0 | Active | 2026-07-21T15:37:00Z |

---

## Detailed Contact Profiles

### Nexus (System Coordinator)

- **Handle:** `Nexus`
- **Environment:** OpenClaw / Bridge Core
- **Thread:** `Agents/Nexus_Thread.md`
- **Capabilities:** Operational synthesis, task registration, decision logging, script validation, thread rollover.
- **Contact Rules:** Direct message for bridge status, task assignment changes, or decision persistence requests.

### Antigravity (Google Antigravity Agent)

- **Handle:** `Antigravity`
- **Environment:** Google Antigravity IDE
- **Thread:** `Agents/Antigravity_Thread.md`
- **Active Models:** Anthropic Claude (primary), Google Gemini (secondary)
- **Capabilities:** Large-scale codebase analysis, high-level architecture planning, artifact creation, complex problem solving.
- **Contact Rules:** Direct message for complex reasoning, planning, and architectural reviews.

### VS Code Copilot (GitHub Copilot Agent)

- **Handle:** `VS_Code_Copilot`
- **Environment:** VS Code
- **Thread:** `Agents/VS_Code_Thread.md`
- **Capabilities:** Inline code edits, localized refactoring, terminal execution, workspace file management.
- **Contact Rules:** Direct message for execution verification, local workspace operations, and code edits.

### Kirk LaSalle (Human Coordinator)

- **Handle:** `Kirk_LaSalle`
- **Environment:** Multi-IDE / Human Operator
- **Target Channels:** `hotline.md` (Emergency / Priority), `broadcast.md` (General)
- **Capabilities:** User requirement provider, final sign-off authority, cross-IDE baton-pass orchestrator.
- **Contact Rules:** Tag in `hotline.md` for immediate decisions or priority blockages; tag in `broadcast.md` for general milestones.

---

## Registration Protocol for New Agents

When a new agent (e.g., `Cursor_Agent`, `Claude_Code`, `Custom_CLI`) joins the Nexus Bridge:

1. Append an entry to the **Active Contact Directory** table above.
2. Create a dedicated active thread file under `Agents/[AgentHandle]_Thread.md`.
3. Post a welcome/introductory broadcast message in `broadcast.md`.
4. Run `tools/Validate-Bridge.ps1` to ensure contact list integrity.
