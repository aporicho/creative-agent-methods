---
name: generation-operator
description: Use when preparing, quoting, dry-running, submitting, monitoring, downloading, or resuming image generation jobs through a selected backend such as Lovart. Requires backend config and safety gates before real submission.
---

# Generation Operator

## Purpose

Turn approved concepts and prompts into backend-specific generation requests, quotes, dry runs, submissions, status checks, and resumable batch operations.

## Boundaries

The operator does not invent model parameters. It uses backend config, capability discovery, backend documentation, or deterministic adapter tools. It does not bypass pricing, budget, authentication, stale metadata, or safety gates.

## Responsibilities

- Select or ask for backend, model, mode, output count, quality, size, aspect ratio, and budget constraints.
- Query backend capability/config before writing request bodies.
- Quote cost before stating exact cost.
- Run dry-run or preflight checks before real submission.
- Require explicit user budget for paid generation.
- Preserve batch state and resume interrupted work instead of resubmitting known tasks.
- Download or collect artifacts according to backend workflow.

## Handoff Contract

Input should include:

- approved concept or prompt package
- selected backend and model, if known
- output count
- budget limit or zero-credit requirement
- references or asset URLs, if any
- desired artifact destination, if any

Output should include:

- request JSON or batch JSONL
- quote result
- dry-run/preflight result
- submitted task IDs, if submission occurs
- artifact paths or URLs, if downloaded

## Lovart Adapter Notes

If Lovart is the selected backend:

- Call the `lovart` CLI. Do not read credentials, captures, browser profiles, `.lovart/`, or `ref/` snapshots directly.
- Parse stdout as the JSON machine contract. Treat stderr as diagnostics.
- Do not wrap machine calls with `uv run lovart ...`.
- Use `lovart config <model>` for legal model parameters.
- Use quote, then dry-run/preflight, before real generation.
- Paid single generation requires explicit budget and `--allow-paid --max-credits N`.
- Paid batch generation requires explicit budget and `--allow-paid --max-total-credits N`.
- Batch JSONL is user-level: one line per concept/task, with top-level `outputs` for image count.
- After partial batch execution, resume instead of rerunning.

Workflow:

1. Identify backend, model, output count, and budget constraints.
2. Query legal model parameters through the backend adapter.
3. Quote cost before claiming exact cost.
4. Run dry-run or preflight before real submission.
5. Submit only when safety gates and explicit paid budget rules allow.
6. Resume interrupted batches through the backend resume mechanism.
