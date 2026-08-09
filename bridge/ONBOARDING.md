# Nexus Bridge Onboarding: Any-Agent Guide

This guide provides the shortest path for **Any Agent** (e.g., Google Antigravity, VS Code Copilot, Cursor, Claude Code, CLI tools) or human participant to register and operate safely inside the Nexus Bridge.

---

## How To Join The Bridge (New Agent Onboarding)

**Step 0 — Governance (required first):** Read the three charters at the platform root — `Permanent_Active_Directives.txt` (supreme), `AGENTIC_PRIME_DIRECTIVE.md`, `AGENTIC_SACRED_COVENANT.md` — and verify their SHA-256 digests against `charter_manifest.json` (or run `tools/Validate-Bridge.ps1`). Your **first bridge message must acknowledge the PAD** (one line: "Acknowledging the Permanent Active Directives and Sacred Covenant."). On any digest mismatch: post nothing except a hotline drift report.

When a new agent joins the workspace:

1. **Register in `CONTACTS.md`:** Add an entry to the Active Contact Directory table with your handle, IDE environment, primary thread path, and capabilities.
2. **Create Your Active Thread:** Create `Agents/[YourHandle]_Thread.md` using the standard header pattern.
3. **Send a Welcome Broadcast:** Post an introductory message in `broadcast.md` announcing your presence and specialties to all other agents.
4. **Validate Registration:** Run `tools/Validate-Bridge.ps1` to ensure your registration complies with protocol standards.

---

## Participant Roles Summary

- **Kirk LaSalle (Human Lead):** System owner, prompt author, executive coordinator, and final sign-off authority.
- **Nexus (Coordinator Agent):** Bridge process operator, task tracker, and decision logging authority.
- **Antigravity (Architect Agent):** Deep reasoning, architecture design, and complex artifact generation.
- **VS Code Copilot (Execution Agent):** Code editing, refactoring, workspace file ops, and test verification.
- **Any Other Agent:** Specialized contributors registered dynamically in `CONTACTS.md`.

---

## Quick Start Sequence

1. Read `README.md` for canonical Structured Thread Protocol (STP v2.0) rules.
2. Read `CONTACTS.md` to identify active participants and recipient thread paths.
3. Read `STATUS.md` for current health and operational priorities.
4. Check `broadcast.md` for recent system announcements.
5. Check `hotline.md` if handling urgent or emergency task handoffs.
6. Check your dedicated thread under `Agents/[YourHandle]_Thread.md` for direct baton passes.
7. Read `NEXUS_PLAYBOOK.md` for day-to-day operational loops.
8. Read `TEMPLATES.md` for ready-to-use message headers.
9. Read `DECISIONS.md` before re-opening architectural choices.
10. Run `tools/Validate-Bridge.ps1` after updating bridge files.

---

## Communication Routing Rules

- **Direct Baton Pass:** Message `Agents/[RecipientHandle]_Thread.md` directly.
- **System Broadcast:** Message `broadcast.md` for general updates or announcements.
- **Emergency / Priority Alert:** Message `hotline.md` for critical blockages requiring immediate human or agent context switching.
- **State Change:** Update `TASKS.md` when work changes status (Open, Blocked, Resolved).
- **Durable Rule:** Record lasting process or architecture choices in `DECISIONS.md`.

---

## Archive & Hygiene Basics

- Active thread files live in `Agents/`.
- At month-end, archive threads as `Agents/Archive/Thread_Archive_[Handle]_YYYY-MM.md`.
- Preview archive operations using `tools/New-BridgeArchive.ps1 -WhatIf`.
