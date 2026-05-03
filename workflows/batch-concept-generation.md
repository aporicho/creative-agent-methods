# Workflow: Batch Concept Generation

1. Define the project-level world, visual style, audience, intended use, and negative constraints.
2. Convert each user-level idea into one structured concept, not one concept per output image.
3. Group concepts by visual function so the batch does not collapse into repeated standing subjects, identical lenses, or the same emotional beat.
4. Vary camera, composition, scale, environment, subject function, and story moment across groups.
5. Preserve each concept's `core`, `story_moment`, and `primary_subject` across refinements unless reconstruction is explicitly requested.
6. Mark reconstruction separately when a concept's core meaning changes.
7. Produce concepts that can be reviewed before prompt conversion.

Output artifact: an array of `VisualConcept` objects matching `schemas/concept.schema.json`.
