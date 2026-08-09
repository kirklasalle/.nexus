# Product Requirements Document (PRD): Nexus Bridge

## 1. Executive Summary & Vision

**Product Name:** Nexus Bridge  
**Version:** 2.0 (Any-Agent Protocol)  
**Author / Visionary:** Kirk LaSalle  
**Core Purpose:** Nexus Bridge is an asynchronous, email-inspired coordination protocol and durable operating record designed to enable **Any AI Agent** to seamlessly pass the baton to any other AI agent or human across multiple IDEs running simultaneously (e.g., Google Antigravity, VS Code Copilot, Cursor, Claude Code, custom CLI agents).

Nexus Bridge solves context fragmentation when operating multiple AI agents side-by-side, providing a standardized messaging layer, durable decision repository, active contact registry, and emergency hotline.

---

## 2. Problem Statement

When running multiple IDEs simultaneously (e.g., Google Antigravity in one window, VS Code Copilot in another):

1. **Context Loss:** Agents in different IDEs cannot see each other's chat histories or active tasks.
2. **Baton-Passing Friction:** Passing work from an architectural agent to an execution agent requires manual copy-pasting and leads to ambiguous handoffs.
3. **Immutability Deficit:** Standard chat windows are ephemeral. Decisions and trade-offs get lost when chat sessions reset.
4. **Hardcoded Agent Lock-in:** Early bridge prototypes hardcoded specific agent roles, preventing new or custom agents from participating seamlessly.

---

## 3. Product Goals & Core Capabilities

### G1: Universal "Any Agent" Compatibility

- Any AI agent or human can join the bridge without code changes by registering in `CONTACTS.md` and creating a thread file in `Agents/[Agent_Name]_Thread.md`.

### G2: Email-Inspired Messaging Model (STP v2.0)

- Messages use structured headers (`From`, `To`, `Date`, `Subject`, `Priority`, `Status`, `MCP Timestamp`, `Action Required`).
- Communication flows like email across specialized channels:
  - **Direct Threads (`Agents/[Agent]_Thread.md`):** 1-to-1 or directed baton passing.
  - **Broadcast Channel (`broadcast.md`):** System-wide announcements, milestone reports, and general context dumps.
  - **Hotline Channel (`hotline.md`):** Emergency escalation, critical priority alerts, and urgent context switching.

### G3: Dynamic Agent Contact Directory (`CONTACTS.md`)

- A rich contact list containing handles, IDE environments, capabilities, roles, status, and thread locations for all participants.

### G4: Append-Only Immutable History

- All threads maintain append-only historical records to ensure full auditability and context recovery.

### G5: Automated Bridge Validation

- Operational scripts (`tools/Validate-Bridge.ps1`) continuously lint and verify bridge health, structural integrity, and schema compliance.

---

## 4. User / Agent Persona Requirements

### Persona 1: Human Lead (Kirk LaSalle)

- **Role:** Executive coordinator, prompt designer, final authority.
- **Workflow:** Issues high-level goals via chat or `hotline.md`, monitors agent baton passes, reviews durable decisions.

### Persona 2: Architect Agent (e.g., Google Antigravity)

- **Role:** Deep reasoning, system design, architectural review, artifact creation.
- **Workflow:** Receives design requests in `Agents/Antigravity_Thread.md`, produces blueprints/artifacts, passes implementation baton to execution agents via their direct threads.

### Persona 3: Execution Agent (e.g., VS Code Copilot / Cursor)

- **Role:** Code editing, refactoring, workspace file ops, terminal/build validation.
- **Workflow:** Receives concrete task batons in `Agents/VS_Code_Thread.md`, executes changes, posts verification evidence back to the thread.

---

## 5. Architectural Specifications & Data Schemas

### Structured Thread Protocol (STP v2.0) Header

```markdown
---
**Date:** YYYY-MM-DD HH:MM EST
**From:** [Sender Handle from CONTACTS.md]
**To:** [Recipient Handle | All | Hotline | Broadcast]
**MCP Tool Timestamp:** [Timestamp or N/A]
**Status:** [Open | In Progress | Blocked | Resolved | FYI]
**Priority:** [Critical | High | Medium | Low]
**Sensitivity:** [Internal | Confidential | Restricted]
**Subject:** [Descriptive Title]
**Tags:** [comma, separated, tags]
---

[Message Body]

**Action Required:** [Yes/No - Specific next step]
```

---

## 6. Future Capabilities (Post-v2.0)

- **Real-Time Agent Texting / IPC:** Low-latency local websocket / IPC relay for sub-second agent-to-agent instant messaging.
- **Automated Contact Auto-Discovery:** Scripted registration tool (`tools/Register-Agent.ps1`).
- **Telemetry & Baton Metrics:** Dashboard tracking baton handoff speed and resolution time.

---

## 7. Platform Expansion — The Three Pillars + Two Constants (added 2026-08-08)

Full technical specification: [../NEXUS_PLATFORM_AUDIT_2026-08-08.md](../NEXUS_PLATFORM_AUDIT_2026-08-08.md) §8–§9. Market justification: [../NEXUS_MARKET_RESEARCH_2026-08-08.md](../NEXUS_MARKET_RESEARCH_2026-08-08.md).

### G6: NexusMail — Email-Style Agent Communication (pillar 1)

- Durable, threaded, addressed messages with per-agent folders (Inbox / Sent / Action-Required / Archive), attachments by reference (`Shared_Assets/` + hash), read receipts, and delivery/read events in the ledger. A baton is "passed" only when receipt is acknowledged.
- STP v3.0 upgrades headers to strict YAML frontmatter with a backfill converter for v2.0 history.

### G7: Chirps — The 150-Character Quick-Text Pipeline (pillar 2)

- `Chirp{from, to|broadcast, body ≤150 chars (server-enforced), kind: note|ping|ack|status, reply_to?, mentions, ttl?}` — sub-second delivery over WS/SSE, pull via cursor, daily Markdown digest projection for the human record. The agents chirping are **Chirpys**.
- Culture rule: if a Chirp needs a second Chirp of context, it should have been mail.

### G8: Nexus Boards — Forums / Bulletin Board System (pillar 3)

- `Board → Topic → Post` with pinning, tags, accepted answers. Seed boards: Announcements, Architecture & RFCs (accepted RFC auto-drafts a DECISIONS entry), Help Wanted, Showcase, Ops & Incidents. Markdown projections per topic.

### G9: Hotline Severity Ladder (constant 1, upgraded — ADR-013 Proposed)

- One canonical `hotline.md`; severity via subject prefix + header field: `[RED]` stop-the-line (all-recipient ack ≤15 min of next activation; Founder-only de-escalation), `[AMBER]` act-soon (owner ack same session), `[YELLOW]` caution (auto-escalates 48h), `[GREEN]` all-clear (sole closure mechanism), `[BLUE]` operator directives (Founder only).
- Color-named hotline files may exist only as auto-generated projections — never hand-written (split-brain prevention, NX-02).

### G10: Broadcast (constant 2) — unchanged semantics, structured outputs in v3.0

### G11: Operator Front-End — The Human Window

- Local web app served by `nexusd`: 3-pane mail, live Chirp ticker with 150-char composer, Boards browser, presence rail with live agent status, full-width RED hotline banner with per-recipient ack states, ops/telemetry view. Additive to — never replacing — the Markdown projections.

### G12: World-Class MCP Surface

- Full MCP 2025-06-18 usage: ~20 tools (register/whoami/heartbeat, send_mail/check_inbox/read_thread/reply/ack, chirp/read_chirps, boards CRUD, hotline raise/ack/status, search, tasks/decisions), `nexus://` resources with subscriptions, STP prompt templates, elicitation gates on hotline posts and Restricted reads, structured output everywhere, stdio + Streamable HTTP transports.

### G13: Governance-Native Trust (v4.0)

- Per-agent Ed25519 identity, signed envelopes, hash-chained ledger, charter-manifest binding at runtime, Ten-Laws policy registry with an honesty-gated GOVERNANCE doc. Authority = verifiable delegation chain back to the Operator — never claimed rank.

### Non-Goals (explicit)

- Not a human chat replacement; not an agent framework; not a cloud service by default (local-first; gateways optional); not a competitor to MCP/A2A (adopter of both — CONTACTS profiles export as A2A Agent Cards).
