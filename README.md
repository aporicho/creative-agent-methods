# Creative Agent Methods

A portable creative-agent capability pack for visual concept design, AIGC prompt design, and generation workflow operation.

This project is intentionally backend-neutral. It describes how an AI coding or creative agent should think, structure outputs, and hand work off to generation backends such as Lovart, OpenAI Images, ComfyUI, Seedream, Midjourney-like systems, or future adapters.

## Positioning

```text
Lovart or another backend = execution system
Creative Agent Methods = expert capability pack
```

The capability body is:

```text
roles + workflows + schemas
```

Platform support is distribution packaging:

```text
Codex skills
Claude Code skills or instruction files
OpenCode agents
OpenClaw agents
plain Markdown manuals
```

The source of truth stays in portable Markdown role specs, workflow specs, and schema contracts.

## Design Principle

```text
Expert methods = role specs + workflows + schemas
Execution backends = adapters + tools + safety gates
Platform support = thin packaging around the same expert methods
```

Do not put credentials, browser captures, runtime state, provider-specific secrets, or generated private artifacts in this repository.

## Contents

- `roles/`: reusable expert role specifications.
- `workflows/`: task workflows that combine roles.
- `schemas/`: portable JSON schemas for concept and generation planning artifacts.
- `adapters/`: backend-specific execution notes.
- `platforms/`: packaging for Codex, Claude Code, OpenCode, and OpenClaw.

## Roles

- `concept-designer`: turns creative goals into structured visual concepts.
- `aigc-prompt-designer`: converts approved concepts into executable prompt packages.
- `generation-operator`: prepares backend-specific generation plans, quotes, dry runs, submissions, monitoring, and resumes.

## Backend Relationship

Backends own real execution behavior. For example, Lovart should remain responsible for:

- CLI JSON contracts
- legal model configuration
- quote and cost semantics
- dry-run and preflight behavior
- paid budget gates
- batch job semantics
- resume behavior
- forbidden paths and safety rules

This package may include a Lovart adapter, but Lovart itself remains the source of truth for Lovart runtime rules.

## Recommended Use

Use role specs to guide the agent's thinking. Use workflows to compose roles into repeatable operations. Use schemas to stabilize handoff artifacts. Use backend adapters only when a real generation provider is selected.

When adding a new backend, add a file under `adapters/` that explains capability discovery, legal parameters, quote, dry-run, submission, status, artifact collection, and resume behavior. Do not bake those details into the generic roles.

## Install

This package ships a bootstrap installer and a local CLI for installing the platform wrappers.

One-command install, Codex by default:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
```

Install a specific target:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- codex
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- claude
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- opencode --dest /path/to/project/.opencode/agents
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- openclaw --dest /path/to/project/.openclaw/agents
```

The bootstrap installer downloads this repository into `~/.creative-agent-methods/repo`, installs the `creative-agent-methods` command into `~/.local/bin`, then installs the selected platform wrapper.

You can also run the CLI directly from a local checkout:

```bash
./bin/creative-agent-methods install codex
```

Or install only the command into `~/.local/bin`:

```bash
./bin/creative-agent-methods install-cli
```

Then use:

```bash
creative-agent-methods install codex
creative-agent-methods install claude
creative-agent-methods install opencode --dest /path/to/project/.opencode/agents
creative-agent-methods install openclaw --dest /path/to/project/.openclaw/agents
creative-agent-methods install all
```

Default destinations:

- Codex: `${CODEX_SKILLS_DIR:-~/.codex/skills}`
- Claude Code: `${CLAUDE_SKILLS_DIR:-~/.claude/skills}`
- OpenCode: `${OPENCODE_AGENTS_DIR:-$PWD/.opencode/agents}`
- OpenClaw: `${OPENCLAW_AGENTS_DIR:-$PWD/.openclaw/agents}`

By default the CLI copies files. Use `--mode link` to install symlinks back to this repository, and `--force` to replace existing installed files with the same names.
