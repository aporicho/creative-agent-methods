# Claude Code Packaging

Recommended packaging: expose each role as a Claude skill generated from `templates/skill/`.

Generated skill names:

- `concept-designer`
- `aigc-prompt-designer`
- `generation-operator`

The installed files are self-contained, but the repository source of truth remains `roles/`, `adapters/`, and `templates/`.
