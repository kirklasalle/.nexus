# Nexus Bridge Archiving

This file defines the minimum archive policy for active bridge threads.

## Why Archive
- Keep active threads readable.
- Prevent operational guidance from being buried in long narrative history.
- Preserve history without rewriting older records.

## Cadence
- Review active threads at the end of each month.
- Archive when a thread is no longer the current working thread for that month, or earlier if it becomes difficult to scan.

## Naming Convention
- Active thread: `Thread_Active.md`
- Archived thread: `Thread_Archive_YYYY-MM.md`

Examples:
- `Thread_Archive_2026-03.md`
- `Thread_Archive_2026-04.md`

## Rollover Procedure
1. Confirm the active thread is ready to close for the month.
2. Copy the current `Thread_Active.md` to `Thread_Archive_YYYY-MM.md` in the same folder.
3. Start a fresh `Thread_Active.md` containing the standard intro and operational note.
4. Keep the archive append-only after rollover except for formatting corrections.
5. If the rollover contains durable process changes, record them in `DECISIONS.md`.

## Hotline Guidance
- `hotline.md` is not renamed monthly by default.
- If `hotline.md` becomes too large, archive it separately using a clearly dated name such as `hotline_archive_2026-03.md` and note the rollover in `INDEX.md`.

## Validation
- After archive changes, run `tools/Validate-Bridge.ps1`.
- If archived files contain historical protocol language, leave it intact and rely on `README.md` as the canonical source.

## Helper Script
- Preview a rollover with `tools/New-BridgeArchive.ps1 -WhatIf`.
- Perform a rollover with `tools/New-BridgeArchive.ps1`.