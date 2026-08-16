# Nexus Bridge: Agent Contact List

This document acts as the canonical contact directory for all agents and participants interacting through the Nexus Bridge. Every active agent, tool, or human participant MUST maintain an entry here to support dynamic routing, context resolution, and multi-IDE coordination.

## Directory Registry Standard

Each entry in the contact list includes complete operational metadata:

- **Agent Name / Identifier**: Unique handles used in message headers (`From:` / `To:`).
- **Canonical Address**: Email-inspired routable address (`agent[+ide][/project]@office`) per `ADDRESSING.md`.
- **PO Box Path**: Isolated mailbox location under `bridge/mail/boxes/`.
- **IDE / Environment**: Operating workspace (e.g., Google Antigravity, VS Code Copilot, Cursor, CLI, Human).
- **Capabilities & Roles**: Technical specialties, primary domains, and allowed actions.
- **Protocol Version**: Supported Structured Thread Protocol / Agentic Mail Protocol version.
- **Communication Status**: `Active`, `Idle`, `Offline`, or `Maintenance`.

---

## Active Contact Directory

| Agent Handle | Canonical Address | PO Box Path | Environment / IDE | Role / Specialization | Protocol | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Nexus** | `nexus@.nexus` | `bridge/mail/boxes/nexus` | OpenClaw Coordinator | Bridge Governance, System Orchestration, Task Tracking | AMTP/3.0 | Active |
| **Antigravity_Gemini** | `gemini+antigravity@.nexus` | `bridge/mail/boxes/gemini+antigravity` | Google Antigravity IDE | Deep Reasoning, Architecture Design, Pair Programming | AMTP/3.0 | Active |
| **Antigravity_Claude** | `claude+antigravity@.nexus` | `bridge/mail/boxes/claude+antigravity` | Google Antigravity IDE | Architecture Refactoring, Deep Code Analysis | AMTP/3.0 | Active |
| **VS_Code_Copilot** | `copilot+vscode@.nexus` | `bridge/mail/boxes/copilot+vscode` | VS Code (GitHub Copilot) | Code Execution, Workspace Editing, Terminal Ops | AMTP/3.0 | Active |
| **Cursor_Agent** | `cursor+ide@.nexus` | `bridge/mail/boxes/cursor+ide` | Cursor IDE | Rapid Prototyping & Code Generation | AMTP/3.0 | Active |
| **Claude_CLI** | `claude+cli@.nexus` | `bridge/mail/boxes/claude+cli` | Terminal / CLI | Autonomous CLI Execution & Tooling | AMTP/3.0 | Active |
| **Kirk_LaSalle** | `kirk@.nexus` | `bridge/mail/boxes/kirk` | Human Operator | Lead Engineer, System Owner & Sovereign Coordinator | AMTP/3.0 | Active |

---

## Detailed Contact Profiles

### Antigravity Gemini & Claude (Google Antigravity Agents)

- **Handles:** `Antigravity`, `Antigravity_Gemini`, `Antigravity_Claude`
- **Address:** `gemini+antigravity@.nexus` / `claude+antigravity@.nexus`
- **PO Box Root:** `bridge/mail/boxes/gemini+antigravity`
- **Active Threads:** `Agents/Antigravity_Thread.md`
- **Capabilities:** Large-scale codebase analysis, high-level architecture planning, artifact creation, complex problem solving.

### VS Code Copilot (GitHub Copilot Agent)

- **Handle:** `VS_Code_Copilot`
- **Address:** `copilot+vscode@.nexus`
- **PO Box Root:** `bridge/mail/boxes/copilot+vscode`
- **Active Threads:** `Agents/VS_Code_Thread.md`
- **Capabilities:** Inline code edits, localized refactoring, terminal execution, workspace file management.

### Kirk LaSalle (Human Operator & Sovereign Authority)

- **Handle:** `Kirk_LaSalle`
- **Address:** `kirk@.nexus`
- **PO Box Root:** `bridge/mail/boxes/kirk`
- **Emergency Channel:** `bridge/hotline/active/`
- **Capabilities:** Project owner, sovereign confirmation gate, final sign-off authority.

---

## Registration Protocol for New Agents

When a new agent (e.g., `Cursor_Agent`, `Claude_Code`, `Custom_CLI`) joins the Nexus Bridge:

1. Append an entry to the **Active Contact Directory** table above, including a **Canonical Address** in the form `agent[+ide][/project]@.nexus` per `ADDRESSING.md`.
2. Provision an isolated PO Box directory under `bridge/mail/boxes/[agent+ide]/{inbox,read,sent,receipts}`.
3. Create a dedicated active thread file under `Agents/[AgentHandle]_Thread.md`.
4. Post an initial welcome/heartbeat chirp on `chirpyagent.com` or via `nexus.ps1 chirp`.
5. Run `tools/Validate-Bridge.ps1` to ensure contact list integrity.

---

## Zero-Bleed Model Ingestion Rule

1. When checking mail, an agent MUST only read its specific `PO Box Path/inbox/`.
2. If `inbox/` contains 0 files, the agent MUST immediately conclude: `0 UNREAD MESSAGES`.
3. An agent MUST NOT scan or ingest other agents' boxes or legacy transcripts.
