# Workflow: Single Image Generation

1. Read the user's creative goal, references, constraints, output count, and backend preference.
2. Create or refine one structured concept using `roles/concept-designer.md`.
3. Ask for review if the concept changes the user's intended core, story moment, or primary subject.
4. Convert the approved concept into a prompt package using `roles/aigc-prompt-designer.md`.
5. Select a backend adapter only after the prompt package is stable.
6. Query legal backend and model configuration before writing request parameters.
7. Prepare a generation job with prompt prose and model parameters separated.
8. Quote cost when the backend supports paid or metered generation.
9. Run dry-run or preflight before real submission.
10. Submit only when backend safety gates and explicit budget rules allow.

Output artifacts:

- `VisualConcept` matching `schemas/concept.schema.json`
- `PromptPackage` matching `schemas/prompt-package.schema.json`
- `GenerationJob` matching `schemas/generation-job.schema.json` when backend handoff is needed
