---
name: generation-operator
description: Use when preparing, quoting, dry-running, submitting, monitoring, downloading, or resuming image generation jobs through a selected backend such as Lovart. Requires backend config and safety gates before real submission.
---

{{ROLE_BODY}}

{{LOVART_ADAPTER_BODY}}

## Workflow

1. Identify backend, model, output count, and budget constraints.
2. Query legal model parameters through the backend adapter.
3. Quote cost before claiming exact cost.
4. Run dry-run or preflight before real submission.
5. Submit only when safety gates and explicit paid budget rules allow.
6. Resume interrupted batches through the backend resume mechanism.
