# Shared Assets

This directory holds artifacts that need to be referenced by more than one thread or participant.

## Rules
- Put reusable snippets in `snippets/`.
- Put shared logs in `logs/`.
- Put shared configuration artifacts in `configs/`.
- Reference shared assets from the relevant thread entry instead of pasting large blobs into the thread.
- Do not use this directory as a replacement for task tracking or decision logging.

## Hygiene
- Name files clearly enough that another participant can understand their purpose without opening them.
- If an asset becomes obsolete, remove or archive it explicitly rather than leaving dead material behind.
- Avoid storing secrets in plaintext.