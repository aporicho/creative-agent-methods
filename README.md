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

This package ships a lightweight installer for installing only the files needed by the selected platform.

Interactive install:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
```

The installer asks which platform to install, downloads only the required skill or agent files, and writes them to the platform destination.

The installed platform files are self-contained. They do not require this repository, the `roles/` directory, or the `adapters/` directory to exist on the user's machine.

Direct install:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- codex
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- claude
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- opencode --project .
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- openclaw --project .
```

The remote installer does not clone this repository, does not install a global CLI, and does not keep a package copy on disk.

Default destinations:

- Codex: `${CODEX_SKILLS_DIR:-~/.codex/skills}`
- Claude Code: `${CLAUDE_SKILLS_DIR:-~/.claude/skills}`
- OpenCode: `${OPENCODE_AGENTS_DIR:-<project>/.opencode/agents}`
- OpenClaw: `${OPENCLAW_AGENTS_DIR:-<project>/.openclaw/agents}`

Use `--dest <dir>` to override the destination for one target, `--force` to replace existing files, and `--dry-run` to preview the install.

## Local CLI

Maintainers can also run the repository CLI directly from a local checkout:

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

By default the CLI copies files. Use `--mode link` to install symlinks back to this repository, and `--force` to replace existing installed files with the same names.
