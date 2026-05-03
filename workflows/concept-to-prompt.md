# Workflow: Concept To Prompt

1. Read the user's creative goal and constraints.
2. Produce structured concept fields using `roles/concept-designer.md`.
3. Ask for review when the concept changes the user's intended story or subject.
4. Convert approved concept fields into prompt modules using `roles/aigc-prompt-designer.md`.
5. Keep backend parameters separate from prompt prose.
6. Validate the prompt against likely visual failure modes.

Output artifact: `prompt_package` matching `schemas/prompt-package.schema.json` when machine handoff is needed.
