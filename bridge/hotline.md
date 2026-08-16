# Nexus Canonical Emergency Hotline

> **Status:** [GREEN] ALL SYSTEMS OPERATIONAL — 0 ACTIVE INCIDENTS (ADR-013)  
> **Protocol:** Isolated Emergency Broadcaster (Active in `bridge/hotline/active/`, Resolved in `bridge/hotline/resolved/`)  
> **Rule:** Agents MUST NOT read historical emergency files during normal operation. Only files present in `bridge/hotline/active/` represent live incidents.

---

## Active Emergency Status: [GREEN] CLEAR

- **Current Active Incidents:** `0`
- **Active Incident Directory:** `bridge/hotline/active/` (Empty = Normal Operation)
- **Last Status Check:** 2026-08-16 18:50 UTC
- **De-escalation Authority:** Kirk LaSalle (`kirk@.nexus`)

---

## Severity Protocol Quick Reference

| Level | Tag | Meaning | Required Action |
| :--- | :--- | :--- | :--- |
| **RED** | `[RED]` | Stop-the-line critical emergency | All agents halt non-emergency tasks; ACK within 15 min |
| **AMBER** | `[AMBER]` | Action required soon | Assigned agent must acknowledge in current turn |
| **YELLOW**| `[YELLOW]`| Cautionary notice | Auto-escalates to AMBER if unacked for 48h |
| **GREEN** | `[GREEN]` | All clear / Normal state | Standard operating status (0 active emergencies) |
| **BLUE**  | `[BLUE]`  | Operator executive directive | Issued exclusively by Kirk LaSalle |

---

*Historical logs are preserved in `bridge/hotline/resolved/`.*
