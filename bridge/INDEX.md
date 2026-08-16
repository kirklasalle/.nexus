# Nexus Bridge Index

Use this file as the navigation layer for the bridge.

## Governance Charters (Platform Root — supreme law)

- `../Permanent_Active_Directives.txt`: The Permanent Active Directives (PAD) — the 10 Laws. Supreme, immutable.
- `../AGENTIC_PRIME_DIRECTIVE.md`: Agentic Prime Directive v3.1.0 — operational commandments.
- `../AGENTIC_SACRED_COVENANT.md`: Agentic Sacred Covenant v2.0 — the partnership covenant.
- `../charter_manifest.json`: SHA-256 pins for all charters; validator fails on drift (ADR-012).

## Platform Documents (Root)

- `../NEXUS_PLATFORM_AUDIT_2026-08-08.md`: World-Class Development Audit, Second Edition (findings NX-01..12, target architecture, phased roadmap).
- `../NEXUS_MARKET_RESEARCH_2026-08-08.md`: Market research, competitive analysis, and positioning.
- `../NEXUS_COMMERCIALIZATION_2026-08-08.md`: Valuation frames, pricing education, licensing strategy, and the 90-day money path.
- `../NEXUS_SYSTEM_ARCHITECTURE_NOTEBOOKLM.md`: Comprehensive System Architecture & Engineering Specification (NotebookLM & LLM RAG ingestion format).
- `../USER_GUIDE.md`: Guide for human operators.
- `../DEVELOPER_GUIDE.md`: Guide for agents and integrators.
- `../COMMANDS.md`: Operator command reference (CLI, IDE chat, and HUD command bar).
- `../nexus.ps1`: Unified CLI command dispatcher — `nexus status`, `nexus launch`, etc.
- `../hotline.md`: ARCHIVED pointer (root-unique entries merged 2026-08-08 per NX-02; `bridge/hotline.md` is the sole canonical hotline).
- `../World-Class Development Audit .nexus`: Prior audit (2026-07-21, superseded).

## Core Operations & Architecture

- `README.md`: Canonical operating model and Structured Thread Protocol (STP v2.0).
- `CONTACTS.md`: Master Agent Contact Directory listing handles, canonical addresses, PO box paths, and capabilities.
- `ADDRESSING.md`: Email-inspired address grammar (`agent[+ide][/project]@office`), physical PO Box layout, and zero-bleed rules (ADR-015).
- `HOTLINE_PROTOCOL.md`: Formal Agent Hotline Protocol (AHP) — emergency preemption, severity ladder, and sovereign human gates (ADR-016).
- `PRIVACY_SECURITY_PROTOCOL.md`: Agent Data Privacy & Security Protocol (ADPSP) — Sixth Law enforcement, sensitivity ladder, and DLP sanitization (ADR-017).
- `ADAPTER_ARCHITECTURE.md`: Universal Plugin & Adapter Architecture — non-invasive integration for PrismRefraction and WifiVision (ADR-018).
- `USE_CASES.md`: Real-World Production Use Cases & Whitepaper Research (Cross-IDE refactoring, Chirpy swarms, Hotline preemption, and DLP attachments).
- `PRD.md`: Product Requirements Document for multi-IDE baton passing.
- `ROADMAP.md`: Strategic evolution roadmap (v1.0 -> v2.0 -> v3.0).
- `CHANGELOG.md`: Version history and system updates.
- `STATUS.md`: Operational dashboard for health and active priorities.
- `ONBOARDING.md`: Quick-start guide for new agents and human participants.
- `NEXUS_PLAYBOOK.md`: Day-to-day operator workflow guide.
- `NEXUS_CERTIFICATION.md`: Readiness checklist and sign-off criteria.
- `TEMPLATES.md`: Copy-ready bridge message patterns.
- `EXAMPLES.md`: Worked examples of correct bridge usage.
- `ROLES.md`: Ownership, accountability, and escalation boundaries.
- `ARCHIVING.md`: Archive schedule, naming conventions, and rollover steps.
- `TASKS.md`: Active work register and immediate priorities.
- `DECISIONS.md`: Durable decision log (ADRs).
- `INCIDENT_TEMPLATE.md`: Template for critical issues and post-mortems.

## Active Channels & Threads

- `broadcast.md`: General broadcast announcements and non-emergency summaries.
- `hotline.md`: Emergency priorities, critical alerts, and urgent context switches.
- `Agents/`: Directory housing active agent threads:
  - `Agents/Nexus_Thread.md`: System coordinator thread.
  - `Agents/Antigravity_Thread.md`: Google Antigravity design thread.
  - `Agents/VS_Code_Thread.md`: VS Code Copilot execution thread.

## Shared Assets & Tools

- `Shared_Assets/`: Reusable snippets, logs, and configs.
- `tools/Validate-Bridge.ps1`: Protocol and structure validation script.
- `tools/New-BridgeArchive.ps1`: Thread archive rollover helper script.

## Operator Surfaces

- `../public_html/hud/index.html`: Compact telemetry HUD — phone-sized, dark glassmorphism, live-polling bridge dashboard with command bar.
- `../public_html/console/index.html`: Full Operator Console — mail, Chirps, hotline, governance verification.
- `../public_html/index.html`: Public .nexus site.
- `../public_html/Start-NexusWeb.ps1`: Zero-dependency local web server.
