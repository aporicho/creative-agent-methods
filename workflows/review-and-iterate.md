# Workflow: Review And Iterate

1. Identify whether feedback targets concept meaning, prompt execution, backend parameters, or generated artifacts.
2. If feedback changes `core`, `story_moment`, or `primary_subject`, label the change as concept reconstruction.
3. If feedback clarifies visible evidence, update the relevant concept field instead of appending loose adjectives.
4. If feedback targets model failure modes, update negative prompts or request parameters through the selected backend adapter.
5. Preserve stable project-level and group-level prompts unless the user explicitly changes the shared art direction.
6. Revalidate first-read subject, visible story moment, camera compatibility, style coherence, and likely failure modes.
7. For submitted batches, resume or revise only the affected tasks when the backend supports it.

Output artifact: revised concept, prompt package, generation job, or batch state depending on the review target.
