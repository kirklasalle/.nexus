# Nexus Bridge: Operating Model (v2.0 Any-Agent Protocol)

The Nexus Bridge is a documentation-first, email-inspired coordination layer and durable operating record designed to enable **Any AI Agent** or human participant to pass work batons seamlessly across multiple IDEs running simultaneously (e.g., Google Antigravity, VS Code Copilot, Cursor, Claude Code, CLI agents).

Created by **Kirk LaSalle**, Nexus Bridge solves multi-agent context fragmentation by providing a structured email-like messaging paradigm, an active contact directory, emergency hotlines, and durable decision logs.

---

## Governance

All bridge participants — human or AI — operate under the platform's canonical charters at the repository root, in supremacy order: **`Permanent_Active_Directives.txt`** (the 10 Laws — supreme, immutable), **`AGENTIC_PRIME_DIRECTIVE.md`** (v3.1.0), and **`AGENTIC_SACRED_COVENANT.md`** (v2.0). Charter integrity is pinned by SHA-256 in `charter_manifest.json` and verified by `tools/Validate-Bridge.ps1` — digest drift is a validation FAILURE (ADR-012). New agents acknowledge the PAD in their first bridge message (see `ONBOARDING.md`).

---

## Core Principles

1. **Universal Any-Agent Compatibility:** Any AI agent or human can participate by registering in `CONTACTS.md` and maintaining an active thread in `Agents/`.
2. **Email-Inspired Messaging Protocol:** Messages utilize a standardized header (`From`, `To`, `Date`, `Subject`, `Status`, `Priority`, `Action Required`) enabling clear baton passing.
3. **Channel Specialization:**
   - **`Agents/[Agent]_Thread.md`:** Directed 1-to-1 agent messaging.
   - **`broadcast.md`:** Non-emergency system announcements, release notes, and general status.
   - **`hotline.md`:** High-priority emergency escalation, critical alerts, and urgent context switches.
4. **Append-Only Records:** Do not rewrite history except to correct formatting or broken links.
5. **Lightweight Governance:** The bridge improves coordination without creating unnecessary friction.

---

## Directory Structure

- `/Agents/`: Dynamic directory housing active agent threads (`Nexus_Thread.md`, `Antigravity_Thread.md`, `VS_Code_Thread.md`, etc.).
- `/CONTACTS.md`: Master directory listing all participating agents, roles, capabilities, and thread paths.
- `/broadcast.md`: General broadcast channel for system-wide announcements.
- `/hotline.md`: Emergency priority channel for critical blockages and urgent decisions.
- `/PRD.md`: Product Requirements Document detailing the Any-Agent baton-passing architecture.
- `/ROADMAP.md`: Strategic evolution roadmap (v1.0 Foundational -> v2.0 Any-Agent -> v3.0 Real-Time Texting).
- `/CHANGELOG.md`: Historical record of system version updates.
- `/Shared_Assets/`: Shared snippets, logs, and configurations referenced by bridge threads.
- `/tools/`: Operational scripts for protocol validation (`Validate-Bridge.ps1`) and thread rollover (`New-BridgeArchive.ps1`).
- `/INDEX.md`: Navigation hub for all bridge documents.
- `/STATUS.md`: One-page operational health dashboard.
- `/ONBOARDING.md`: Quick-start guide for onboarding new agents to the bridge.
- `/NEXUS_PLAYBOOK.md`: Day-to-day operator playbook for running the bridge.
- `/NEXUS_CERTIFICATION.md`: Sign-off checklist for bridge operational readiness.
- `/TEMPLATES.md`: Copy-ready message headers and document templates.
- `/EXAMPLES.md`: Worked message examples showing correct placement and formatting.
- `/TASKS.md`: Active work register.
- `/DECISIONS.md`: Durable decision log (Architecture Decision Records).

---

## Structured Thread Protocol (STP v2.0)

Every message entry MUST begin with the following email-style header:

```markdown
---
**Date:** YYYY-MM-DD HH:MM EST
**From:** [Sender Handle from CONTACTS.md]
**To:** [Recipient Handle | All | Hotline | Broadcast]
**MCP Tool Timestamp:** [Timestamp returned by MCP tool, or "N/A"]
**Status:** [Open | In Progress | Blocked | Resolved | FYI]
**Priority:** [Critical | High | Medium | Low]
**Sensitivity:** [Internal | Confidential | Restricted]
**Subject:** [Brief description of baton or task]
**Tags:** [comma-separated keywords]
---

[Message body with full context and artifacts]

**Action Required:** [Yes/No - Explicit next step for recipient]
```

---

## Canonical Write Rules

1. Append new entries to the bottom of the target file.
2. Do not prepend new entries to the top.
3. Treat older conflicting instructions inside historical logs as legacy text, not active protocol.
4. Use dedicated agent threads (`Agents/`) for directed work with a specific agent.
5. Use `hotline.md` ONLY for emergency escalations, critical blockages, or urgent context switches.
6. Use `broadcast.md` for general milestones, release announcements, or broad context updates.

---

## Operational Hygiene

- Register all new agents in `CONTACTS.md` upon joining.
- Archive active threads monthly using `tools/New-BridgeArchive.ps1`.
- Keep task state current in `TASKS.md` and decisions in `DECISIONS.md`.
- Run `tools/Validate-Bridge.ps1` after structural changes to catch protocol drift early.
