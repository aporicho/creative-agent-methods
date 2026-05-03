#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="creative-agent-methods"
DEFAULT_REF="main"
DEFAULT_RAW_BASE="https://raw.githubusercontent.com/aporicho/creative-agent-methods/${DEFAULT_REF}"

usage() {
  cat <<'EOF'
Creative Agent Methods installer

Usage:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- <target> [options]

Targets:
  codex      Install Codex skills.
  claude     Install Claude Code skills.
  opencode   Install OpenCode agents.
  openclaw   Install OpenClaw agents.
  all        Install all platform wrappers.

Options:
  --dest <dir>       Destination directory for one target.
  --project <dir>    Project directory for opencode/openclaw. Installs into .opencode/.openclaw under it.
  --force            Replace existing files.
  --dry-run          Show actions without writing files.
  -h, --help         Show this help.

Environment:
  CREATIVE_AGENT_METHODS_RAW_BASE    Raw file base URL. Defaults to GitHub main branch.
  CREATIVE_AGENT_METHODS_SOURCE_DIR  Local source checkout for testing or offline installs.
  CODEX_SKILLS_DIR                   Default Codex destination.
  CLAUDE_SKILLS_DIR                  Default Claude destination.
  OPENCODE_AGENTS_DIR                Default OpenCode destination.
  OPENCLAW_AGENTS_DIR                Default OpenClaw destination.

Examples:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- codex
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- claude
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- opencode --project .
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- openclaw --project .
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

expand_path() {
  local input="$1"
  case "$input" in
    "~") printf '%s\n' "$HOME" ;;
    "~/"*) printf '%s/%s\n' "$HOME" "${input#~/}" ;;
    *) printf '%s\n' "$input" ;;
  esac
}

is_interactive() {
  [[ -t 0 ]]
}

prompt_target() {
  if ! is_interactive; then
    die "no target provided and stdin is not interactive; pass codex, claude, opencode, openclaw, or all"
  fi

  cat >&2 <<'EOF'
Choose a platform to install Creative Agent Methods:
  1) Codex skills
  2) Claude Code skills
  3) OpenCode agents
  4) OpenClaw agents
  5) All
  q) Quit
EOF

  local choice
  while true; do
    printf 'Platform [1-5/q]: ' >&2
    read -r choice
    case "$choice" in
      1|codex|Codex) printf 'codex\n'; return ;;
      2|claude|Claude) printf 'claude\n'; return ;;
      3|opencode|OpenCode) printf 'opencode\n'; return ;;
      4|openclaw|OpenClaw) printf 'openclaw\n'; return ;;
      5|all|All) printf 'all\n'; return ;;
      q|Q|quit|exit) exit 0 ;;
      *) printf 'Please choose 1, 2, 3, 4, 5, or q.\n' >&2 ;;
    esac
  done
}

prompt_project_dir() {
  local target="$1"
  local default_project="$PWD"
  local project

  if ! is_interactive; then
    printf '%s\n' "$default_project"
    return
  fi

  printf 'Project directory for %s [%s]: ' "$target" "$default_project" >&2
  read -r project
  if [[ -z "$project" ]]; then
    project="$default_project"
  fi
  printf '%s\n' "$project"
}

default_dest() {
  local target="$1"
  local project_dir="${2:-}"

  case "$target" in
    codex)
      printf '%s\n' "${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
      ;;
    claude)
      printf '%s\n' "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
      ;;
    opencode)
      if [[ -n "${OPENCODE_AGENTS_DIR:-}" ]]; then
        printf '%s\n' "$OPENCODE_AGENTS_DIR"
      else
        [[ -n "$project_dir" ]] || project_dir="$(prompt_project_dir opencode)"
        printf '%s/.opencode/agents\n' "$(expand_path "$project_dir")"
      fi
      ;;
    openclaw)
      if [[ -n "${OPENCLAW_AGENTS_DIR:-}" ]]; then
        printf '%s\n' "$OPENCLAW_AGENTS_DIR"
      else
        [[ -n "$project_dir" ]] || project_dir="$(prompt_project_dir openclaw)"
        printf '%s/.openclaw/agents\n' "$(expand_path "$project_dir")"
      fi
      ;;
    *)
      die "unknown target: $target"
      ;;
  esac
}

manifest() {
  local target="$1"
  case "$target" in
    codex)
      cat <<'EOF'
platforms/codex/skills/concept-designer/SKILL.md|concept-designer/SKILL.md
platforms/codex/skills/aigc-prompt-designer/SKILL.md|aigc-prompt-designer/SKILL.md
platforms/codex/skills/generation-operator/SKILL.md|generation-operator/SKILL.md
EOF
      ;;
    claude)
      cat <<'EOF'
platforms/claude/skills/concept-designer/SKILL.md|concept-designer/SKILL.md
platforms/claude/skills/aigc-prompt-designer/SKILL.md|aigc-prompt-designer/SKILL.md
platforms/claude/skills/generation-operator/SKILL.md|generation-operator/SKILL.md
EOF
      ;;
    opencode)
      cat <<'EOF'
platforms/opencode/agents/concept-designer.md|concept-designer.md
platforms/opencode/agents/aigc-prompt-designer.md|aigc-prompt-designer.md
platforms/opencode/agents/generation-operator.md|generation-operator.md
EOF
      ;;
    openclaw)
      cat <<'EOF'
platforms/openclaw/agents/concept-designer.md|concept-designer.md
platforms/openclaw/agents/aigc-prompt-designer.md|aigc-prompt-designer.md
platforms/openclaw/agents/generation-operator.md|generation-operator.md
EOF
      ;;
    *)
      die "unknown target: $target"
      ;;
  esac
}

download_file() {
  local source_path="$1"
  local output_path="$2"
  local raw_base="${CREATIVE_AGENT_METHODS_RAW_BASE:-$DEFAULT_RAW_BASE}"

  mkdir -p "$(dirname "$output_path")"

  if [[ -n "${CREATIVE_AGENT_METHODS_SOURCE_DIR:-}" ]]; then
    local local_source
    local_source="$(expand_path "$CREATIVE_AGENT_METHODS_SOURCE_DIR")/$source_path"
    [[ -f "$local_source" ]] || die "local source file not found: $local_source"
    cp "$local_source" "$output_path"
  else
    command -v curl >/dev/null 2>&1 || die "required command not found: curl"
    curl -fsSL "${raw_base}/${source_path}" -o "$output_path"
  fi
}

install_target() {
  local target="$1"
  local dest="$2"
  local force="$3"
  local dry_run="$4"

  dest="$(expand_path "$dest")"
  info "Installing $target"
  info "  to: $dest"

  local source_path rel_path final_path tmp_path
  while IFS='|' read -r source_path rel_path; do
    [[ -n "$source_path" ]] || continue
    final_path="$dest/$rel_path"

    if [[ -e "$final_path" && "$force" != "1" ]]; then
      info "  skip existing: $final_path"
      continue
    fi

    if [[ "$dry_run" == "1" ]]; then
      info "  install: $source_path -> $final_path"
      continue
    fi

    mkdir -p "$(dirname "$final_path")"
    tmp_path="${final_path}.tmp.$$"
    download_file "$source_path" "$tmp_path"
    mv "$tmp_path" "$final_path"
    info "  installed: $rel_path"
  done < <(manifest "$target")
}

parse_options() {
  DEST=""
  PROJECT_DIR=""
  FORCE="0"
  DRY_RUN="0"

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --dest)
        [[ "$#" -ge 2 ]] || die "--dest requires a directory"
        DEST="$2"
        shift 2
        ;;
      --project)
        [[ "$#" -ge 2 ]] || die "--project requires a directory"
        PROJECT_DIR="$2"
        shift 2
        ;;
      --force)
        FORCE="1"
        shift
        ;;
      --dry-run)
        DRY_RUN="1"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "unknown option: $1"
        ;;
    esac
  done
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  local target=""
  if [[ "$#" -gt 0 && "${1:-}" != --* ]]; then
    target="$1"
    shift
  fi

  parse_options "$@"

  if [[ -z "$target" ]]; then
    target="$(prompt_target)"
  fi

  case "$target" in
    codex|claude|opencode|openclaw|all) ;;
    *) die "unknown target: $target" ;;
  esac

  if [[ "$target" == "all" ]]; then
    [[ -z "$DEST" ]] || die "--dest can only be used with one target"
    local each each_dest
    for each in codex claude opencode openclaw; do
      each_dest="$(default_dest "$each" "$PROJECT_DIR")"
      install_target "$each" "$each_dest" "$FORCE" "$DRY_RUN"
    done
  else
    local dest="$DEST"
    if [[ -z "$dest" ]]; then
      dest="$(default_dest "$target" "$PROJECT_DIR")"
    fi
    install_target "$target" "$dest" "$FORCE" "$DRY_RUN"
  fi
}

main "$@"
