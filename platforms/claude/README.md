# Claude Code Packaging

Recommended packaging: expose each role as a Claude skill or project instruction file.

Provided skill wrappers:

- `concept-designer`
- `aigc-prompt-designer`
- `generation-operator`

Files live under `platforms/claude/skills/`.

Keep backend adapters as separate references so the creative roles remain provider-neutral.
