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