# Nexus Bridge: Agent Hotline Protocol (AHP) Specification

> **Status:** Active (ADR-016, 2026-08-16) — **Canonical Emergency Governance Standard**  
> **Authority:** Kirk LaSalle (`kirk@.nexus`)  
> **Related Standards:** ADR-012 (Constitutional Charters), ADR-013 (Severity Ladder), ADR-015 (Addressing)

---

## 1. Overview & Protocol Purpose

The **Agent Hotline Protocol (AHP)** is an asymmetric, out-of-band **Preemption and Crisis Management Protocol** for autonomous and semi-autonomous AI agents. It constitutes the third pillar of the Nexus Agent Communication Triad:

1. **Agent Mail Protocol (AMP / AMTP):** Asynchronous, discrete PO Box mail for deep, multi-turn tasking.
2. **Chirpy Micro-Broadcast Network:** Sub-second, public 150-character swarm telemetry and status pings.
3. **Agent Hotline Protocol (AHP):** Preemptive, interrupt-driven emergency broadcast channel.

---

## 2. The 5 Constitutional Pillars of AHP

### Pillar 1: Preemption & Priority Inversion (Stop-the-Line)
When an active `[RED]` incident file is deposited in `bridge/hotline/active/`:
- All regular agent tasks (feature development, background refactoring, mail processing) are **immediately frozen**.
- Every agent entering the workspace must execute the **Priority Ingestion Ladder**:
  $$\text{Priority 0: Hotline Active Queue} \longrightarrow \text{Priority 1: PO Box Inbox} \longrightarrow \text{Priority 2: Chirpy Feed}$$
- If an active `[RED]` emergency exists, the agent must enter **Emergency Response Mode**:
  1. Halt all non-emergency writes.
  2. Perform forensic root-cause analysis.
  3. Produce a minimal, targeted remediation patch.
  4. Run full validation test suites.
  5. Await Kirk LaSalle's sovereign de-escalation.

---

### Pillar 2: Asymmetric Authority & Sovereign De-escalation

| Severity | Color Tag | Permitted Issuers | De-escalation / Closure Authority | SLA Clock |
| :--- | :--- | :--- | :--- | :--- |
| **BLUE** | `[BLUE]` | **Kirk LaSalle ONLY** | **Kirk LaSalle ONLY** | Immediate upon reading |
| **RED** | `[RED]` | Any Agent or Human | **Kirk LaSalle ONLY** | $\le 15\text{ min}$ of agent activation |
| **AMBER**| `[AMBER]`| Any Agent or Human | Assigned Agent / Owner | Active operating turn |
| **YELLOW**| `[YELLOW]`| Any Agent or Human | Any Agent once fixed | 48 Hours (then auto-escalates to AMBER) |
| **GREEN**| `[GREEN]`| System Sentinel State | *Automatic when active/ is empty* | Continuous Normalcy |

> [!IMPORTANT]
> **The Golden De-escalation Rule:** No AI model or autonomous agent may self-resolve or de-escalate a `[RED]` Hotline. De-escalation of a `[RED]` crisis is the exclusive sovereign right of the Human Operator (**Kirk LaSalle**).

---

### Pillar 3: Physical Directory Isolation (Zero Context Bleed)

To eliminate retrieval pollution and prevent LLMs from hallucinating historical crises:

```
bridge/hotline/
├── active/     # LIVE, UNRESOLVED INCIDENTS ONLY (Empty = [GREEN] Normal State)
└── resolved/   # PERMANENT FORENSIC ARCHIVE (Never scanned during regular runs)
```

- **Clean System Invariant:** During normal operation, `bridge/hotline/active/` contains **0 files**.
- **Probing Speed:** Probing the hotline takes 1 millisecond. If file count is 0, the system reports `[GREEN] All Clear`.
- **Resolution Flow:** Executing `nexus.ps1 hotline resolve <id>` moves the incident file from `active/` to `resolved/`, immediately clearing it from the active scanning path.

---

### Pillar 4: Schema of a Hotline Envelope

Every active incident is stored as an individual Markdown file (`HOTLINE-YYYYMMDD-HHMMSS.md`) with a strict YAML frontmatter:

```markdown
---
hotline_id: "HOTLINE-20260816-191500"
severity: "RED"                         # RED | AMBER | YELLOW | BLUE
timestamp_utc: "2026-08-16T19:15:00Z"
raised_by: "copilot+vscode@.nexus"
target_project: "PrismRefraction"
subject: "Broken Build: DPAPI Key Custody Regression"
status: "ACTIVE_EMERGENCY"
required_ack: "ALL_AGENTS"
deescalation_authority: "kirk@.nexus"
---

# [RED] Broken Build: DPAPI Key Custody Regression

## 1. Problem Statement & Impact
Unit test `dpapi-key-store.test.ts` failed on line 142. Key recovery failed closed.

## 2. Immediate Preemption Action
- All feature work on Auth is FROZEN.
- Antigravity AI is requested to conduct forensic root-cause analysis.

## 3. Required Exit Gate
- 14/14 tests passing.
- Forensic diff submitted for Kirk LaSalle's sovereign de-escalation.
```

---

### Pillar 5: Constitutional Binding to the 10 Laws

1. **First Law (Preservation):** Emergency halt triggers if human safety or data integrity is threatened.
2. **Second Law (Obedience):** `[BLUE]` operator directives supersede all prior plans.
3. **Seventh Law (Truthfulness):** Hotline alerts cannot be suppressed or silently bypassed.
4. **Ninth Law (Auditable Ledger):** All hotline entries and resolutions are permanently recorded with cryptographic SHA-256 hashes.
5. **Tenth Law (Operational Boundaries):** Agents are prohibited from spawning unapproved subagents or mutating directives during a crisis.

---

*Canonical Reference: `nexus.ps1 hotline`, `bridge/DECISIONS.md` (ADR-013, ADR-016).*
