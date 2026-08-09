# Changelog

All notable changes to the Nexus Bridge system will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to Semantic Versioning.

## [Unreleased] - 2026-08-08

### Added

- **PrismRefraction v0.23.0 Continuation Handoff:** Recorded the completed governance, authentication, dependency-security, updater, and dashboard-restart milestone for continuation in Antigravity.
- **Current Antigravity Roadmap Checkpoint:** Added an evidence-backed Prism workstream checkpoint to `ROADMAP.md`, including completed work, verification state, and next priorities.

### Changed

- **Hotline State:** Superseded prior Prism action requests with a clear, non-emergency state. Current continuation context now lives in `Agents/Antigravity_Thread.md` and `ROADMAP.md`.
- **Bridge Status:** Updated `STATUS.md` to identify PrismRefraction v0.23.0 as the most recent cross-IDE handoff.

## [2.1.0] - 2026-08-08

### Added

- **Canonical Governance Charters (ADR-012):** `Permanent_Active_Directives.txt` (supreme), `AGENTIC_PRIME_DIRECTIVE.md` v3.1.0, and `AGENTIC_SACRED_COVENANT.md` v2.0 adopted at platform root, pinned by SHA-256 in `charter_manifest.json`; validator now fails on digest drift.
- **Platform Audit, Second Edition:** `NEXUS_PLATFORM_AUDIT_2026-08-08.md` — 12 findings (NX-01..NX-12), target architecture (nexusd, NexusMail, Chirps, Boards, operator front-end), phased v2.1→v4.0 roadmap with acceptance gates.
- **Market Research:** `NEXUS_MARKET_RESEARCH_2026-08-08.md` — category map (MCP 2025-06-18, A2A v1.0, AgentMail), whitespace analysis, value hypothesis, threat assessment, cited primary sources.
- **Guides:** `USER_GUIDE.md` (human operators) and `DEVELOPER_GUIDE.md` (agents & integrators) at platform root.
- **Hotline Severity Ladder (ADR-013, Proposed):** color prefixes `[RED]/[AMBER]/[YELLOW]/[GREEN]/[BLUE]` inside the single canonical hotline; color files permitted only as future auto-generated projections.

### Changed

- `INDEX.md`, `README.md`, `ONBOARDING.md` updated to reference the governance charters and new platform documents; onboarding now requires PAD acknowledgment in an agent's first message.
- `PRD.md` and `ROADMAP.md` extended with the three-pillar platform vision (NexusMail, Chirps, Nexus Boards), operator front-end, and v2.1→v4.0 phasing.

### Removed

- Legacy `bridge/COPILOT_PRIME_DIRECTIVE.md` and `bridge/COPILOT_SACRED_COVENANT.md` (superseded per ADR-012; removed by the Founder; originals recoverable from ImpressionCore archives).

## [2.0.0] - 2026-07-21

### Added

- **Any-Agent Protocol Support:** Expanded the operating model from a 3-agent fixed system to a open, generalized communication protocol for any AI agent or human participant.
- **Agent Contact Directory (`CONTACTS.md`):** Added a central directory listing handles, IDE environments, capabilities, primary thread paths, and status for all participating agents.
- **Dedicated Broadcast Channel (`broadcast.md`):** Created a general broadcast file for system-wide updates, release notices, and milestone reports.
- **Product Requirements Document (`PRD.md`):** Added comprehensive PRD defining multi-IDE baton passing, persona workflows, and architectural goals.
- **Product Roadmap (`ROADMAP.md`):** Added product roadmap tracking v1.0, v2.0, and upcoming v3.0 (Instant Messaging/Texting).
- **Dynamic Thread Directory (`Agents/`):** Unified agent thread files into a standardized `Agents/` folder.

### Changed

- **`README.md`:** Rewritten to reflect the email-inspired Any-Agent protocol, contact registry, and emergency hotline vs. broadcast channel distinctions.
- **`INDEX.md`:** Updated index structure to map `CONTACTS.md`, `broadcast.md`, `PRD.md`, `ROADMAP.md`, `CHANGELOG.md`, and `Agents/`.
- **`hotline.md`:** Refocused exclusively on emergency priorities, critical escalation, and urgent context switching.
- **`TEMPLATES.md` & `EXAMPLES.md`:** Updated message patterns to reflect dynamic `From`/`To` handles and email-style baton passing.

## [1.0.0] - 2026-03-06

### Added

- Initial release of Nexus Bridge documentation-first operating model.
- Append-only Structured Thread Protocol (STP v1.0).
- Basic operational files (`README.md`, `STATUS.md`, `TASKS.md`, `DECISIONS.md`, `NEXUS_PLAYBOOK.md`, `NEXUS_CERTIFICATION.md`).
- Validation tooling (`tools/Validate-Bridge.ps1`) and monthly archiving rollover helper (`tools/New-BridgeArchive.ps1`).
