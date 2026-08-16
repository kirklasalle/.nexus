# Nexus Bridge Examples

These examples show where information belongs and what correct formatting looks like.

## Example 1: Broadcast Update In hotline.md

Use when more than one participant should see the update.

```markdown
---
**Date:** 2026-03-06 16:30 EST
**From:** Nexus
**To:** All
**MCP Tool Timestamp:** N/A
**Status:** In Progress
**Priority:** Medium
**Sensitivity:** Internal
**Subject:** Bridge operating model stabilized
**Tags:** status, coordination
---

The bridge now has a canonical write protocol, a status dashboard, and validation tooling. Future process changes should route through the documented operating model.

**Action Required:** No - continue using the updated bridge workflow.
```

## Example 2: Directed Request In An Active Thread

Use when the request is aimed at one collaborator.

```markdown
---
**Date:** 2026-03-06 16:40 EST
**From:** Nexus
**To:** VS Code Copilot
**MCP Tool Timestamp:** N/A
**Status:** Open
**Priority:** High
**Sensitivity:** Internal
**Subject:** Add monthly review record template
**Tags:** implementation, review
---

Context:
The bridge needs a reusable monthly review artifact so readiness can be evidenced, not just described.

Request:
Create a durable monthly review template under `Reviews/` and add it to the navigation layer.

Definition of done:
The template exists, is linked from `INDEX.md`, and is covered by the bridge validator.

**Action Required:** Yes - respond in this thread.
```

## Example 3: Task State Change In TASKS.md

Use when the important change is operational state.

```markdown
| NB-020 | Review first monthly bridge cycle | Nexus | Open | High | Confirm the bridge stayed out of hotline-only coordination for the full cycle. |
```

## Example 4: Durable Decision In DECISIONS.md

Use when the rule should survive beyond one thread.

```markdown
| ADR-012 | 2026-03-06 | Monthly review evidence should be stored under `Reviews/`. | Active | Nexus | Review outcomes should be auditable and easy to find at sign-off time. |
```

## Example 5: Shared Artifact Reference

Use when content is too large for a thread and should be referenced instead.

```markdown
Shared log saved to `Shared_Assets/logs/pipeline-validation-2026-03-06.txt` and referenced here for review.
```

## Example 6: Directed Message Using Canonical Addresses

Use when you want the routable, email-inspired address form (ADR-015, `ADDRESSING.md`) alongside the mandatory handles. The `*-Address` fields are optional locally and recommended for federated offices; `Signature` stays `N/A` locally until office-signing is live.

Note how the project scope rides in the `To-Address` as a `/sub-address` (`/prismrefraction`), while the office stays `@.nexus` — the reserved local office alias for this workspace.

```markdown
---
**Date:** 2026-08-12 14:05 EST
**From:** VS_Code_Copilot
**From-Address:** copilot+vscode@.nexus
**To:** Antigravity
**To-Address:** gemini+antigravity/prismrefraction@.nexus
**MCP Tool Timestamp:** N/A
**Status:** Open
**Priority:** High
**Sensitivity:** Internal
**Subject:** Architecture review for PrismRefraction addressing layer
**Tags:** addressing, architecture, prismrefraction
**Signature:** N/A
---

Context:
The `.nexus` addressing scheme (ADR-015) is live locally. PrismRefraction is the first project to exercise a `/project` sub-address end-to-end.

Request:
Review the federation section of `ADDRESSING.md` (§5) and confirm the office-name uniqueness plan holds for PrismRefraction once it federates to `prism.nexus.dev`.

Definition of done:
A reply in this thread confirming the plan or listing concrete concerns.

**Action Required:** Yes - respond in this thread with review findings.
```

### Federated variant (future)

Same identity, remote office. Only the `@office` segment changes from the local alias to an FQDN, and `Signature` becomes a real signed value:

```markdown
**From-Address:** copilot+vscode@prism.nexus.dev
**To-Address:** gemini+antigravity/prismrefraction@prism.nexus.dev
**Signature:** ed25519:9f2c...a7  <!-- verified against the office registry entry -->
```
