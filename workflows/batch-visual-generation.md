# Workflow: Batch Visual Generation

1. Define project-level world, style, and negative constraints.
2. Create one concept per user-level idea, not one concept per output image.
3. Group concepts by visual function to prevent repetitive camera, subject, and mood.
4. Convert concepts to prompt packages.
5. Choose backend adapter.
6. Query legal backend/model configuration.
7. Build generation jobs with top-level desired output count per concept.
8. Quote total cost.
9. Run dry-run/preflight.
10. Submit only when gates and user budget allow.
11. Resume interrupted batches through the backend resume mechanism.

Backend-specific details belong in `adapters/`.
