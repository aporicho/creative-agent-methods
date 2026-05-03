# Workflow: Prompt To Request

1. Start from an approved `PromptPackage`.
2. Select a backend adapter.
3. Query backend configuration for legal model, mode, size, quality, aspect ratio, output count, reference input, and safety parameters.
4. Keep prompt prose in prompt fields and model parameters in request fields.
5. Build a backend-specific request body without inventing undocumented parameter values.
6. Quote cost before claiming exact cost when generation is paid or metered.
7. Run dry-run or preflight.
8. Submit only after all required gates pass.
9. Record task IDs, artifact destinations, and resume state.

Output artifact: `GenerationJob` matching `schemas/generation-job.schema.json`.
