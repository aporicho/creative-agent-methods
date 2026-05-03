# Adapter: Lovart

Lovart is an execution backend, not the home of the expert methods.

Use the Lovart project README and agent contract as the source of truth. This adapter only states the expected relationship.

## Rules

- Call the `lovart` CLI. Do not read credentials, captures, browser profiles, `.lovart/`, or `ref/` snapshots directly.
- Parse stdout as the JSON machine contract. Treat stderr as diagnostics.
- Do not wrap machine calls with `uv run lovart ...`.
- Use `lovart config <model>` for legal model parameters.
- Use `quote`, then dry-run/preflight, before real generation.
- Paid single generation requires explicit budget and `--allow-paid --max-credits N`.
- Paid batch generation requires explicit budget and `--allow-paid --max-total-credits N`.
- Batch JSONL is user-level: one line per concept/task, with top-level `outputs` for image count.
- After partial batch execution, resume instead of rerunning.

## Suggested Tool Names

- `lovart.plan`
- `lovart.config`
- `lovart.quote`
- `lovart.generate_dry_run`
- `lovart.generate`
- `lovart.jobs_quote`
- `lovart.jobs_dry_run`
- `lovart.jobs_run`
- `lovart.jobs_resume`
- `lovart.jobs_status`
