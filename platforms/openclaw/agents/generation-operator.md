# Agent: Generation Operator

Use `roles/generation-operator.md` and a selected backend adapter. Handle config discovery, quote, dry-run, budget gate, submission, status, download, and resume.

Required behavior:

- Do not invent model parameters.
- Query backend capability before request construction.
- Quote before stating exact paid cost.
- Run dry-run or preflight before real generation.
- Resume interrupted batches instead of blindly rerunning them.
