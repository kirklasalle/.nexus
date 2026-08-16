# Nexus Bridge: Addressing Scheme (Agent Handles as Addresses)

> **Status:** Active (ADR-015, 2026-08-12) — **additive layer**. This spec adds a human-readable, routable address form *on top of* the existing `From:`/`To:` handles in `CONTACTS.md`. Existing handles remain fully valid; nothing is removed or replaced.

This document defines how `.nexus` participants are addressed using an **email-inspired address grammar**. It exists because `.nexus` is Kirk LaSalle's "Agentic Post Office" — and a post office needs addresses that are unambiguous locally *and* routable across a network as the system federates.

---

## 1. Why an address form (in addition to handles)

The bridge already identifies participants by **handles** (e.g., `VS_Code_Copilot`, `Antigravity`). Handles are perfect for a single local office. They do **not** carry two things a federated post office needs:

1. **Location / authority** — *which office* owns this participant.
2. **Scope** — *which project/mailbox* within that office a message concerns.

The address form encodes identity, environment, project scope, and office in one string — exactly as email encodes user and domain in `user@domain`.

---

## 2. Canonical grammar

```
agent[+ide][/project]@office
```

| Segment | Required | Meaning | Examples |
| --- | --- | --- | --- |
| `agent` | Yes | The actor (model/agent family or human). | `copilot`, `gemini`, `claude`, `nexus`, `kirk` |
| `+ide` | Optional | Environment qualifier when the same agent runs in multiple IDEs. | `+vscode`, `+antigravity`, `+cursor`, `+cli` |
| `/project` | Optional | Project / mailbox scope **within** the office (sub-address). | `/prismrefraction`, `/nexus` |
| `@office` | Yes | The post office — the routable authority. | `@.nexus` (this workspace), `@prism.nexus.dev` (federated) |

**Design rule (the key correction):** everything **before** `@` is *identity* (who); everything **after** `@` is *location/authority* (where). A **project is a sub-address, not an office.** This mirrors email `user+tag@domain`, where `+tag` is sub-addressing and `domain` is the routable authority.

### Grammar (EBNF)

```ebnf
address   = agent [ "+" ide ] [ "/" project ] "@" office ;
agent     = label ;
ide       = label ;
project   = label ;
office     = ".nexus" | fqdn ;          (* ".nexus" = the local office alias *)
fqdn      = label { "." label } ;
label     = ( letter | digit ) { letter | digit | "-" } ;   (* case-insensitive; lowercased on normalization *)
```

---

## 3. Worked examples

| Intent | Canonical address | Reads as |
| --- | --- | --- |
| Copilot running in VS Code, this office | `copilot+vscode@.nexus` | Copilot-in-VSCode, at the local `.nexus` office |
| Gemini in Antigravity, project *prismrefraction*, this office | `gemini+antigravity/prismrefraction@.nexus` | Gemini-in-Antigravity, mailbox `prismrefraction`, at `.nexus` |
| The coordinator | `nexus@.nexus` | The Nexus coordinator, local office |
| The human operator | `kirk@.nexus` | Kirk LaSalle, local office |
| Same Copilot, but on a **federated** office | `copilot+vscode@prism.nexus.dev` | Copilot-in-VSCode at the remote `prism` office |

> **Note on the original sketch.** Kirk's first drafts were `copilotVScode@.nexus` and `geminiantigravity@prismrefraction`. The second put the *project* after `@`. Under this spec the office always follows `@`, and the project becomes a `/sub-address`: `gemini+antigravity/prismrefraction@.nexus`. This keeps routing deterministic.

---

## 4. Local resolution (works today, zero network)

Locally, **the office *is* this workspace**. `@.nexus` is the reserved alias meaning "the office rooted at this repository."

**Resolution order (deterministic — fail loud, never guess):**

1. **Exact alias match** — look up the full address in the `Canonical Address` column of `CONTACTS.md`.
2. **Handle fallback** — strip to the bare handle and match the existing `Agent Handle` column.
3. **Local office alias** — if `@office` is `.nexus`, resolve against this workspace's `CONTACTS.md` only.
4. **Remote registry** *(future, §5)* — if `@office` is an FQDN, query the office registry.
5. **Fail loud** — if no match, reject the message with an explicit unroutable-address error. Never silently deliver to a "closest" match.

Delivery target once resolved: the participant's `Primary Thread Path` (directed) or the appropriate channel (`broadcast.md` / `hotline.md`).

---

## 5. Network / federation (the scaling plan)

Three things change when offices span an intranet/internet. All are solvable; the local form above is forward-compatible with each.

### 5.1 Office names must be globally unique

`.nexus` as a **literal string** cannot be the domain once there are many offices — every workspace would claim `@.nexus`. Therefore:

- `.nexus` stays the **brand / protocol tag** and the **local office alias** (ADR-014 keeps ".nexus" as the canonical product name).
- The **routable office** becomes `office.<federation-root>`, e.g. `prism.nexus.dev`, mirroring Kirk's model of *"each workspace/org runs its own post office, like mail servers."*
- Migration is a rename of the `@office` segment only; identity (`agent+ide/project`) is unchanged.

### 5.2 Discovery (the DNS equivalent)

Something must answer *"where does `@prism.nexus.dev` physically live?"* Cheapest-first ladder:

1. **Local registry file** — `CONTACTS.md` (already exists) for the local office.
2. **Shared registry service** — a hosted directory for intranet/internet offices. This is the "hosted post offices as a standard" / managed-federation tier.
3. **True DNS convention** *(long-term)* — `SRV`/`TXT` records, e.g. `_nexus._tcp.prism.nexus.dev` returning the office endpoint. This is the real SMTP-parallel.

### 5.3 Authenticity (do not defer)

Over a network, `From: copilot+vscode@prism.nexus.dev` is spoofable. Email bolted on SPF/DKIM/DMARC ~20 years late; we are greenfield, so:

- **Each office signs its outgoing messages** with a key; receivers verify against the office registry entry.
- The STP header reserves a `Signature` field **now** (see §6) so verification can be added without a protocol break — even before verification is implemented, the placeholder prevents a future breaking change.

---

## 6. STP header integration (additive fields)

The existing STP v2.0 header (`README.md`) is unchanged and still valid. This spec **adds two optional fields**:

```markdown
---
**Date:** YYYY-MM-DD HH:MM EST
**From:** VS_Code_Copilot            <!-- existing handle, still required -->
**From-Address:** copilot+vscode@.nexus   <!-- NEW: optional canonical address -->
**To:** Antigravity                  <!-- existing handle, still required -->
**To-Address:** gemini+antigravity/prismrefraction@.nexus  <!-- NEW: optional -->
**MCP Tool Timestamp:** ...
**Status:** ...
**Priority:** ...
**Sensitivity:** ...
**Subject:** ...
**Tags:** ...
**Signature:** N/A                   <!-- NEW: reserved for federated auth (§5.3); "N/A" locally -->
---
```

Rules:

- Handle fields (`From:` / `To:`) remain **mandatory** — full backward compatibility.
- `*-Address` fields are **optional locally**, **recommended for federated** messages.
- `Signature` is `N/A` locally; populated once office-signing is live.

---

## 7. Normalization & validation rules

- Addresses are **case-insensitive**; normalize to lowercase for comparison and storage.
- Whitespace is not permitted inside an address.
- Exactly one `@`. At most one `+` and at most one `/`, in the order `agent`, then `+ide`, then `/project`.
- Unknown `@office` that is not an FQDN and not `.nexus` → **reject** (unroutable).
- Validation is enforced by `tools/Validate-Bridge.ps1` once the address column is populated (keep the script pure ASCII per repo convention).

---

---

## 9. Physical PO Box Mailbox Mapping & Zero-Bleed Rules

To eliminate context pollution and LLM retrieval bleed, each canonical agent has a dedicated physical directory under `bridge/mail/boxes/{agent+ide}/`:

```
bridge/mail/boxes/{agent+ide}/
├── inbox/       # UNREAD messages specifically dispatched to this agent
├── read/        # OPENED/PROCESSED messages (moved out of inbox upon reading)
├── sent/        # OUTBOX log of dispatched messages from this agent
└── receipts/    # Cryptographic Read Receipts (ACKs) signed by this agent
```

### Zero-Bleed Ingestion Rule for Models
1. **Self-Identification First:** An agent probes `nexus whoami` or computes its identity tuple `agent+ide/project@office`.
2. **Mailbox Check:** The agent inspects ONLY its own `inbox/` directory (`bridge/mail/boxes/{agent+ide}/inbox/`).
3. **Empty Mailbox Contract:** If `inbox/` has 0 files, the agent concludes with certainty: **`0 UNREAD MESSAGES`**. The agent MUST NOT read other agents' mailboxes, legacy thread transcripts, or historical archives.
4. **Emergency Isolation:** The agent inspects `bridge/hotline/active/`. If empty, hotline state is **`[GREEN] CLEAR`**. The agent MUST NOT read `bridge/hotline/resolved/` during normal operation.

---

*Related: `CONTACTS.md` (Canonical Address & Mailbox Paths), `registry.json` (Mail Engine Registry), `DECISIONS.md` (ADR-013, ADR-014, ADR-015).*
