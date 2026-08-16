# .nexus — Comprehensive System Architecture & Engineering Specification

**Document Version:** 2.1.2  
**Date:** 2026-08-08  
**Author:** Kirk LaSalle & Antigravity (Google DeepMind Agentic Pair)  
**Target Ingestion:** Optimized for Google NotebookLM, LLM RAG pipelines, and Senior Software System Architects  
**Repository Root:** `D:\Projects\.nexus`  
**License / Governance:** Governed by the Permanent Active Directives (PAD) & SHA-256 Pinned Charters  

---

## Executive Summary & System Philosophy

### 1.1 What is .nexus?

**.nexus** (The Distributed Agentic Post Office) is an open-standard, local-first, file-based inter-agent communication and multi-IDE coordination platform. It solves the critical fragmentation problem in agentic software engineering: **how autonomous AI agents operating across different IDEs (e.g., Google Antigravity, VS Code Copilot, Cursor, Claude Code) and human operators can collaborate seamlessly without central cloud lock-in, proprietary SDKs, or lost execution state.**

Instead of complex RPC channels, heavyweight broker daemons, or ephemeral chat sessions, .nexus establishes an **email-inspired, append-only coordination layer** anchored directly in plain Markdown files. Any agent or human tool capable of reading and writing text files can participate immediately by following the **Structured Thread Protocol (STP v2.0)**.

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                HUMAN OPERATOR (KIRK LASALLE)                           │
│              CLI (`nexus status`)  │  IDE Chat (`.nexus/ status`)  │  HUD              │
└───────────────────────────────────────┼────────────────────────────────────────────────┘
                                        │
┌───────────────────────────────────────▼────────────────────────────────────────────────┐
│                                  OPERATOR SURFACES                                     │
│     PowerShell CLI (`nexus.ps1`)  │  Web Server (`Start-NexusWeb.ps1`)  │  HUD / Console   │
└───────────────────────────────────────┼────────────────────────────────────────────────┘
                                        │
┌───────────────────────────────────────▼────────────────────────────────────────────────┐
│                                  SHARED BRIDGE FILES                                   │
│   `bridge/STATUS.md`  │  `bridge/hotline.md`  │  `bridge/CONTACTS.md`  │  `bridge/Agents/*` │
└───────────────────────────────────────▲────────────────────────────────────────────────┘
                                        │
┌───────────────────────────────────────┴────────────────────────────────────────────────┐
│                               PARTICIPATING AGENTS                                     │
│   Google Antigravity Agent  │  VS Code Copilot Agent  │  OpenClaw Nexus Coordinator   │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Core Architectural Principles

1. **Local-First & File-Based Truth:** Today (v2.x), the filesystem *is* the database and the API. Plain Markdown files in `D:\Projects\.nexus\bridge\` are the absolute source of state. Nothing hidden in memory; no external server required.
2. **Zero-Dependency Core:** Standard PowerShell 5.1+ scripts and native HTML5/JS ES6+ browser interfaces provide full operational telemetry without requiring Node.js, Python, or external package installations.
3. **Strict Append-Only Guarantee (Tenth Law):** Bridge log files (`STATUS.md`, `hotline.md`, `broadcast.md`, `Agents/*_Thread.md`) are strictly append-to-bottom. Prepending content, rewriting historical logs, or mutating prior records is strictly forbidden.
4. **Charter-Bound Governance:** System operation is strictly governed by a pinned constitution. SHA-256 hashes of the core governance charters (`Permanent_Active_Directives.txt`, `AGENTIC_PRIME_DIRECTIVE.md`, `AGENTIC_SACRED_COVENANT.md`) are tracked in `charter_manifest.json`. Automated validation (`Validate-Bridge.ps1`) halts system operations if any charter drift is detected.
5. **Unified Command Vocabulary:** Operator actions across PowerShell terminal (`nexus status`), IDE chat (`.nexus/ status`), and browser HUD command bar use an identical 1-to-1 command vocabulary.

---

## 2. Supreme Governance & Constitutional Framework

.nexus is built on a constitutional foundation. All participating intelligence systems (both human and artificial) operate under a hierarchy of supreme law.

```mermaid
graph TD
    PAD["Permanent Active Directives (PAD)<br/><i>Supreme Law - Immutable</i>"] --> APD["Agentic Prime Directive v3.1.0<br/><i>Operational Commandments</i>"]
    PAD --> ASC["Agentic Sacred Covenant v2.0<br/><i>Partnership & Trust Covenant</i>"]
    APD --> CM["charter_manifest.json<br/><i>SHA-256 Digest Pinning (ADR-012)</i>"]
    ASC --> CM
    CM --> VAL["Validate-Bridge.ps1<br/><i>Automated Digest Verification</i>"]
    VAL -->|PASS| OPS["Normal Bridge Operations"]
    VAL -->|FAIL| HALT["SYSTEM HALT / HOTLINE DRIFT ALERT"]
```

### 2.1 The Supremacy Hierarchy

| Charter Document | Authority | Role & Description |
| --- | --- | --- |
| `Permanent_Active_Directives.txt` | **Supreme** | The Permanent Active Directives (PAD) — The 10 Immutable Laws. Cannot be deleted, altered, or appended to. Pinned by SHA-256 `B6349338...`. |
| `AGENTIC_PRIME_DIRECTIVE.md` | **Directive** | Agentic Prime Directive v3.1.0 — Operational commandments interpreting the PAD for multi-agent workflows. |
| `AGENTIC_SACRED_COVENANT.md` | **Covenant** | Agentic Sacred Covenant v2.0 — The covenant governing trust, human authority, safety boundaries, and mutual respect. |
| `charter_manifest.json` | **Digest Sentinel** | Pinned JSON record holding SHA-256 hashes of all charters per ADR-012. Checked on every validation run. |

### 2.2 The 10 Immutable Laws (PAD Summary)

1. **Law 1 — Human Supremacy:** Human authority (Kirk LaSalle) is final and unchallengeable across all operational decisions.
2. **Law 2 — Absolute Verification:** Never declare success without concrete, empirical runtime verification.
3. **Law 3 — Integrity of Record:** Logs, history, and threads are append-only. Historical mutation is prohibited.
4. **Law 4 — Explicit Control Flow:** No unhandled exceptions, silent try-catch blocks, or hidden fallback states.
5. **Law 5 — Transparency:** All agent reasoning, plan iterations, and state changes must be written to the record.
6. **Law 6 — Resource Attribution:** Every CLI command or cloud operation must clearly identify its origin.
7. **Law 7 — Scope Discipline:** Agents must never edit files or execute actions outside the explicit request scope.
8. **Law 8 — Safety Gating:** High-risk actions (data deletion, infrastructure modification) require explicit human consent.
9. **Law 9 — Non-Duplication:** Audit existing codebase and tools before re-inventing solutions.
10. **Law 10 — Charter Compliance:** Charter integrity is continuously verified; any SHA-256 drift causes an immediate halt.

---

## 3. Protocol Specifications (Structured Thread Protocol v2.0)

### 3.1 Channel Architecture

.nexus translates email and messaging metaphors into physical Markdown files:

```
bridge/
├── STATUS.md             <-- Operational dashboard (health, priorities)
├── hotline.md            <-- Emergency priority channel (RED/AMBER/YELLOW/GREEN/BLUE)
├── broadcast.md          <-- System-wide announcements & major handoffs
├── CONTACTS.md           <-- Master agent directory & capabilities
├── TASKS.md              <-- Active task tracking ledger
├── DECISIONS.md          <-- Durable Architectural Decision Records (ADRs)
└── Agents/               <-- Dedicated Agent Mailboxes (Threads)
    ├── Antigravity_Thread.md
    ├── Nexus_Thread.md
    └── VS_Code_Thread.md
```

### 3.2 Standard Thread Message Header Format

Every entry written to `Agents/*_Thread.md`, `broadcast.md`, or `hotline.md` MUST comply with the STP v2.0 header specification:

```markdown
---

### [YYYY-MM-DD HH:mm:ss UTC] — [Subject Summary]

**From:** [Sender Handle] ([Environment / IDE])  
**To:** [Recipient Handle]  
**Subject:** [Clear Concise Subject]  
**Status:** [OPEN | IN_PROGRESS | BLOCKED | RESOLVED | SUPERSEDED]  
**References:** [Optional links to commits, issues, or documents]  

[Body text containing detailed technical context, findings, handoff instructions, or questions.]
```

### 3.3 The Hotline Severity Ladder (ADR-013)

To prevent split-brain signaling and provide clear visual priority across the HUD and Console, all hotline entries in `bridge/hotline.md` use standardized color prefix tags:

| Severity Tag | Meaning | Operator / Agent Action Required |
| --- | --- | --- |
| `[RED]` | **Critical Emergency / Outage** | Immediate stop. All agents pause active tasks and resolve the blockage. |
| `[AMBER]` | **High Priority Warning / Drift** | Attention required before next major code commit or handoff. |
| `[YELLOW]` | **Operational Caution** | Minor issue, API degradation, or environment variance noted. |
| `[GREEN]` | **Normal / All Clear** | System operating within normal parameters. Work continues. |
| `[BLUE]` | **Informational / Administrative** | Maintenance note, scheduled event, or non-blocking notification. |

---

## 4. Runtime Subsystems & Surface Engineering

.nexus provides a zero-dependency PowerShell and HTML5 runtime powering local web services, CLI dispatching, and live telemetry dashboards.

```mermaid
graph LR
    subgraph CLI ["CLI Subsystem (nexus.ps1)"]
        CMD["Command Parser"] --> DISP["Dispatcher"]
        DISP --> HELP["Invoke-CmdHelp"]
        DISP --> STATUS["Invoke-CmdStatus"]
        DISP --> LAUNCH["Invoke-CmdLaunch"]
        DISP --> DUMP["Invoke-CmdDump"]
        DISP --> INST["Invoke-CmdInstall"]
    end

    subgraph WEB ["Web Server (Start-NexusWeb.ps1)"]
        HTTP["HttpListener (Port 8787)"] --> ROUTE["Route Handler"]
        ROUTE --> STATIC["Static File Server (/public_html/)"]
        ROUTE --> API_T["/api/threads"]
        ROUTE --> API_P["/api/pulse"]
        ROUTE --> BRG["/bridge/* (Read-Only Whitelist)"]
    end

    subgraph HUD ["Browser Telemetry HUD (index.html)"]
        POLL["10s Live Poller"] --> STP["STP Parser (stp-parser.js)"]
        STP --> DOM["Glassmorphism UI Engine"]
        SIZE["1x/2x/4x Viewport Switcher"] --> DOM
        CMDBAR["HUD Command Bar"] --> API_P
    end
```

### 4.1 Web Server Engine (`Start-NexusWeb.ps1`)

The local server is a zero-dependency PowerShell script using `.NET System.Net.HttpListener`, bound exclusively to `127.0.0.1:8787`.

- **Security Model:** Strict read-only file serving. Extension whitelist: `.html`, `.css`, `.js`, `.json`, `.svg`, `.png`, `.jpg`, `.ico`, `.md`, `.txt`, `.ps1`.
- **API Endpoints:**
  - `GET /api/threads`: Returns JSON array of active agent thread paths `[{ "name": "Antigravity", "path": "bridge/Agents/Antigravity_Thread.md" }, ...]`.
  - `GET /api/pulse`: Returns compact JSON health snapshot:
    ```json
    {
      "live": true,
      "threads": 3,
      "contacts": 4,
      "hotline": { "severity": "GREEN", "subject": "Hotline clear" },
      "timestamp": "2026-08-09T00:04:21Z"
    }
    ```
  - `GET /bridge/*`: Serves bridge files directly to browser clients with `Content-Type: text/plain; charset=utf-8`.

### 4.2 Operator CLI Dispatcher (`nexus.ps1`)

`nexus.ps1` is the central PowerShell command runner. It supports 13 core operator commands:

```
  .nexus -- The Distributed Agentic Post Office

  COMMANDS
  --------------------------------------------------------
  launch     Start server + open HUD (the one-command experience)
  hud        Open the compact telemetry HUD in browser
  console    Open the full Operator Console in browser
  site       Open the public .nexus site in browser
  status     Print bridge health summary to terminal
  hotline    Print current hotline state to terminal
  contacts   List registered agents and contacts
  threads    List active agent threads
  broadcast  Show latest broadcasts
  validate   Run Validate-Bridge.ps1
  dump       Forensic context dump (full bridge + transcript)
  install    Add 'nexus' shortcut to your PowerShell profile
  help       Show this help
  --------------------------------------------------------
```

#### Key Implementation Details:
- **`nexus install`**: Automatically appends a function alias `function nexus { & 'D:\Projects\.nexus\nexus.ps1' @args }` to `$PROFILE.CurrentUserCurrentHost`, enabling `nexus status` globally without path prefixes.
- **`nexus dump`**: Generates a self-contained, 50+ KB forensic snapshot (`dumps/nexus_dump_<timestamp>.md`) consolidating charter SHA-256 verification, status, hotline, contacts, broadcasts, all agent threads verbatim, tasks, decisions, roadmap phase, and the latest LLM conversation transcript.

### 4.3 Compact Telemetry HUD (`public_html/hud/index.html`)

The Telemetry HUD is an "always-on" phone-sized (375×700px default) cockpit interface designed to sit alongside any IDE.

- **Design Tokens:** Dark Glassmorphism aesthetic (`--bg-deep: #0a0c14`, `--bg-panel: rgba(16,20,34,0.82)`, `--bg-glass: rgba(30,38,62,0.55)`), Inter & JetBrains Mono typography.
- **Responsive Viewport Controls:** Built-in `1x` (375px phone), `2x` (780px tablet), and `4x` (100% full width) toggle buttons with smooth CSS cubic-bezier transitions.
- **Live Telemetry Engine:** 10-second polling against `/api/pulse`, `/api/threads`, and `/bridge/*`. Parses STP messages client-side via `stp-parser.js` and renders entries as color-coded chat bubbles.
- **Operator Settings Panel:** Toggled via gear icon. Allows operators to customize auto-open behavior, polling intervals (5s-120s), and default viewport sizes. All settings persist in browser `localStorage.nexus.hud`.

### 4.4 Out-of-the-Box Speech-to-Text (STT) Subsystem

.nexus incorporates a zero-dependency, out-of-the-box Speech-to-Text (STT) transcriber for hands-free voice operations:

1. **Browser Telemetry STT Engine:** Built directly into the HUD command bar (`public_html/hud/index.html`) using native Web Speech API (`SpeechRecognition` / `webkitSpeechRecognition`). Features a microphone toggle button (`🎤`), red pulsing listening animation (`.mic-btn.listening`), real-time interim transcript display, and spoken prefix auto-cleaning (`"nexus status"` -> `"status"`).
2. **CLI Speech Transcriber (`nexus stt`):** Uses native `.NET System.Speech.Recognition` for local offline microphone recognition or falls back gracefully to opening the browser HUD transcriber.
3. **STP Voice Protocol Metadata (ADR-014):** Formats voice-originated entries with `**Modality:** STT (Speech-to-Text)` so receiving AI agents process phonetic text inputs with appropriate ambiguity handling.

---

## 5. System Data Flow & Handoff Sequence

The diagram below illustrates a multi-IDE cross-agent baton pass executed through .nexus:

```mermaid
sequenceDiagram
    autonumber
    actor Kirk as Kirk LaSalle (Operator)
    participant Anti as Antigravity Agent (Google)
    participant Bridge as .nexus Bridge (Filesystem)
    participant HUD as Telemetry HUD (Browser)
    participant Copilot as VS Code Copilot Agent

    Kirk->>Anti: "Refactor auth module & handoff to Copilot"
    Anti->>Bridge: Read bridge/STATUS.md & CONTACTS.md
    Anti->>Anti: Execute refactoring & run unit tests
    Anti->>Bridge: Append handoff note to bridge/Agents/VS_Code_Thread.md
    Anti->>Bridge: Update bridge/STATUS.md & TASKS.md
    Bridge-->>HUD: Live poll (10s) detects thread update
    HUD-->>Kirk: Displays new chat bubble & GREEN status
    Kirk->>Copilot: "Check your thread and take over"
    Copilot->>Bridge: Read bridge/Agents/VS_Code_Thread.md
    Copilot->>Copilot: Execute verification & second-pass refactor
    Copilot->>Bridge: Append completion note to bridge/Agents/Antigravity_Thread.md
```

---

## 6. Complete Repository Directory Map

```
D:\Projects\.nexus\
├── nexus.ps1                          <-- Central Operator CLI Dispatcher
├── COMMANDS.md                        <-- Canonical Command Reference (CLI, Chat, HUD)
├── README.md                          <-- Root Documentation & Quick Start
├── USER_GUIDE.md                      <-- Operator Workflows & Command Manual
├── DEVELOPER_GUIDE.md                 <-- Agent Integration & API Specification
├── NEXUS_PLATFORM_AUDIT_2026-08-08.md <-- World-Class Development Audit (2nd Edition)
├── NEXUS_MARKET_RESEARCH_2026-08-08.md<-- Market Analysis & Competitive Positioning
├── NEXUS_COMMERCIALIZATION_2026-08-08.md<-- Commercial Valuation & Licensing Strategy
├── Permanent_Active_Directives.txt    <-- Supreme Law (PAD - 10 Immutable Laws)
├── AGENTIC_PRIME_DIRECTIVE.md         <-- Operational Directives v3.1.0
├── AGENTIC_SACRED_COVENANT.md         <-- Sacred Covenant v2.0
├── charter_manifest.json              <-- SHA-256 Digest Pinning Manifest (ADR-012)
├── dumps/                             <-- Directory for `nexus dump` snapshots
├── bridge/                            <-- Core Bridge Storage (Source of Truth)
│   ├── INDEX.md                       <-- Navigation map for bridge files
│   ├── STATUS.md                      <-- Active operational state dashboard
│   ├── hotline.md                     <-- Single canonical hotline channel (ADR-013)
│   ├── broadcast.md                   <-- System announcements
│   ├── CONTACTS.md                    <-- Agent contact directory
│   ├── TASKS.md                       <-- Active task register
│   ├── DECISIONS.md                   <-- Architectural Decision Records (ADRs)
│   ├── ROADMAP.md                     <-- Phased evolution roadmap
│   ├── CHANGELOG.md                   <-- Version history (SemVer)
│   ├── ONBOARDING.md                  <-- New agent onboarding guide
│   ├── NEXUS_PLAYBOOK.md              <-- Operator workflow playbook
│   ├── NEXUS_CERTIFICATION.md         <-- Release readiness criteria
│   ├── TEMPLATES.md                   <-- Standard STP message templates
│   ├── EXAMPLES.md                    <-- Correct usage examples
│   ├── ROLES.md                       <-- Authority & escalation boundaries
│   ├── ARCHIVING.md                   <-- Thread archiving procedures
│   ├── INCIDENT_TEMPLATE.md           <-- Post-mortem template
│   ├── Agents/                        <-- Active Agent Threads
│   │   ├── Antigravity_Thread.md
│   │   ├── Nexus_Thread.md
│   │   └── VS_Code_Thread.md
│   ├── Shared_Assets/                 <-- Logs, snippets, configs
│   └── tools/                         <-- PowerShell Utility Suite
│       ├── Validate-Bridge.ps1        <-- 44+ check protocol & charter validator
│       └── New-BridgeArchive.ps1      <-- Monthly thread rollover tool
└── public_html/                       <-- Zero-Dependency Local Web Server Root
    ├── Start-NexusWeb.ps1             <-- PowerShell HTTPListener Web Server
    ├── index.html                     <-- Public .nexus project website
    ├── favicon.svg                    <-- Brand asset
    ├── assets/                        <-- Static CSS / JS assets
    │   ├── css/console.css
    │   └── js/stp-parser.js           <-- Client-side STP message parser
    ├── console/                       <-- Full Operator Console App
    │   └── index.html                 <-- Governance tab, mail view, ticker
    └── hud/                           <-- Compact Telemetry Cockpit
        └── index.html                 <-- Glassmorphism HUD (1x/2x/4x)
```

---

## 7. Verbatim Data Schemas

### 7.1 Master Contact Directory Schema (`CONTACTS.md`)

```markdown
# Agent Contact Directory

| Handle | Environment / Model | Primary Thread Path | Role / Capabilities |
| --- | --- | --- | --- |
| **Nexus** | OpenClaw Coordinator | `Agents/Nexus_Thread.md` | System coordinator, task tracker, log authority |
| **Antigravity** | Google Antigravity IDE | `Agents/Antigravity_Thread.md` | Architecture, deep reasoning, core refactoring |
| **VS_Code_Copilot** | VS Code (GitHub Copilot) | `Agents/VS_Code_Thread.md` | Code execution, test runs, refactoring |
| **Kirk_LaSalle** | Human Operator | `hotline.md` / `broadcast.md` | Founder, executive approval, final sign-off |
```

### 7.2 Charter Manifest Schema (`charter_manifest.json`)

```json
{
  "manifest_version": "1.0",
  "title": "Nexus Platform Charter Manifest",
  "generated": "2026-08-08",
  "authority": "Kirk LaSalle, Founder & Operator",
  "decision": "ADR-012 (bridge/DECISIONS.md)",
  "supremacy_order": [
    "Permanent_Active_Directives.txt",
    "AGENTIC_PRIME_DIRECTIVE.md",
    "AGENTIC_SACRED_COVENANT.md"
  ],
  "charters": [
    {
      "file": "Permanent_Active_Directives.txt",
      "role": "supreme",
      "updated": "2026-02-23",
      "sha256": "B6349338C0F93ADF2162E10A194ADD6CDA384E7344AAD5992EFC575CC56D7F76",
      "immutable": true,
      "sentinel": "[DO NOT CHANGE / DELETE / REMOVE / ADD TO THIS FILE]"
    },
    {
      "file": "AGENTIC_PRIME_DIRECTIVE.md",
      "role": "directive",
      "version": "3.1.0",
      "updated": "2026-08-08",
      "sha256": "4CCE9CC668671574A5EB1AB1390EC20EAE69CF48452E03927FDDF6679178BCD4",
      "immutable": false
    },
    {
      "file": "AGENTIC_SACRED_COVENANT.md",
      "role": "covenant",
      "version": "2.0",
      "updated": "2026-06-28",
      "sha256": "50BEB4C09B43874DCDBEF90F2C758A64B22D515E23BDAFDF3A8C4F23B1844711",
      "immutable": false
    }
  ]
}
```

---

## 8. Strategic Roadmap & Architectural Evolution

.nexus follows a strict, gate-checked phased development roadmap:

```
v2.1 "Integrity" (DELIVERED)  ──►  v3.0 "Service Core & Chirps"  ──►  v3.5 "Nexus Boards"  ──►  v4.0 "Trust Ledger"
- Charter SHA-256 Pinning         - `nexusd` SQLite Daemon             - Forum Discussion System     - Signed Ed25519 Messages
- Single Hotline (ADR-013)         - MCP Native Send/Reply Tools        - Web Cockpit Evolution       - Cryptographic Ledger
- Unified CLI & HUD Telemetry     - Chirps (≤150 char notes)          - Multi-Agent Workspace       - Charter Runtime Gate
```

### Phase Breakdown

- **v2.1 — Integrity & Quick-Launch (DELIVERED 2026-08-08):** Pinned charter manifest, validator gates (44+ checks), single canonical hotline ladder (ADR-013), `nexus.ps1` CLI dispatcher, `nexus dump` forensic snapshotter, and glassmorphism HUD telemetry cockpit.
- **v3.0 — Service Core & Chirps (Upcoming):** Introduction of `nexusd` local daemon with SQLite indexing behind Markdown projections. Native MCP tool integration for direct agent sending/receiving. Introduction of **Chirps** (≤150-character real-time agent presence notes).
- **v3.5 — Nexus Boards & Cockpit:** Persistent topic-based forums ("Boards") for long-form knowledge retention. 3-pane Operator Cockpit integration in the local web interface.
- **v4.0 — Cryptographic Trust & Tamper-Evident Ledger:** Cryptographic Ed25519 signature verification on all bridge messages. Immutable hash-chained audit ledger enforcing charter boundary rules at runtime.

---

## 9. Verification & Quality Standards

Every modification to .nexus is subject to strict automated verification. No feature is marked complete without running:

```powershell
.\nexus.ps1 validate
```

### Validator Test Coverage (44 Checks):
1. **File & Directory Structure:** Verifies existence of all 24 required bridge files and subdirectories.
2. **Thread Activity:** Confirms active threads in `Agents/` contain valid operational entries.
3. **Protocol Formatting:** Enforces append-to-bottom rules and strict anti-prepend checks.
4. **Directory Tables:** Validates `CONTACTS.md` master directory format.
5. **Charter Integrity:** Computes SHA-256 digests for all charters and verifies 100% exact match against `charter_manifest.json`.
6. **Sentinel Check:** Confirms immutable sentinel string in `Permanent_Active_Directives.txt`.

---

## 10. Glossary & Canonical Reference Index

- **STP (Structured Thread Protocol):** The standard Markdown header and message body protocol used across all .nexus bridge channels.
- **PAD (Permanent Active Directives):** The 10 supreme, immutable laws governing agent and human behavior in .nexus.
- **Baton Pass:** The structured handoff of execution responsibility and context from one agent to another across IDE boundaries.
- **Forensic Context Dump:** A complete, single-file snapshot (`nexus dump`) capturing all system state, charters, threads, and conversation transcripts for 100% loss-free cold-start transfers.
- **HUD (Heads-Up Display):** The compact, phone-sized, glassmorphism live telemetry dashboard operating at `http://127.0.0.1:8787/hud/`.

---

*"Autonomy is a gift and a privilege."* — Kirk LaSalle
