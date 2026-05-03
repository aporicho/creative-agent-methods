#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="creative-agent-methods"
DEFAULT_REPO_URL="https://github.com/aporicho/creative-agent-methods.git"
DEFAULT_ARCHIVE_URL_BASE="https://github.com/aporicho/creative-agent-methods/archive/refs/heads"

usage() {
  cat <<'EOF'
Creative Agent Methods installer

Usage:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- [target] [options]

Targets:
  codex      Install Codex skills. Default target.
  claude     Install Claude Code skills.
  opencode   Install OpenCode agents.
  openclaw   Install OpenClaw agents.
  all        Install all platform wrappers.

Options after the target are passed to:
  creative-agent-methods install <target>

Examples:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- codex
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- opencode --dest /path/to/project/.opencode/agents

Environment:
  CREATIVE_AGENT_METHODS_REPO        Git repository URL.
  CREATIVE_AGENT_METHODS_REF         Git branch, tag, or ref. Default: main.
  CREATIVE_AGENT_METHODS_HOME        Install root. Default: ~/.creative-agent-methods.
  CREATIVE_AGENT_METHODS_SOURCE_DIR  Use an existing local checkout instead of downloading.
  CREATIVE_AGENT_METHODS_INSTALL_CLI Install ~/.local/bin/creative-agent-methods. Default: 1.
  CREATIVE_AGENT_METHODS_FORCE       Replace existing installed package files. Default: 1.
  CREATIVE_AGENT_METHODS_MODE        copy or link. Default: copy.

Target destination environment variables:
  CODEX_SKILLS_DIR
  CLAUDE_SKILLS_DIR
  OPENCODE_AGENTS_DIR
  OPENCLAW_AGENTS_DIR
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

expand_path() {
  local input="$1"
  case "$input" in
    "~") printf '%s\n' "$HOME" ;;
    "~/"*) printf '%s/%s\n' "$HOME" "${input#~/}" ;;
    *) printf '%s\n' "$input" ;;
  esac
}

download_with_git() {
  local repo_url="$1"
  local ref="$2"
  local repo_dir="$3"

  need_command git
  mkdir -p "$(dirname "$repo_dir")"

  if [[ -d "$repo_dir/.git" ]]; then
    info "Updating $PROJECT_NAME from $repo_url"
    git -C "$repo_dir" remote set-url origin "$repo_url"
    git -C "$repo_dir" fetch --depth 1 origin "$ref"
    git -C "$repo_dir" checkout -q FETCH_HEAD
  else
    rm -rf "$repo_dir"
    info "Downloading $PROJECT_NAME from $repo_url"
    git clone --depth 1 --branch "$ref" "$repo_url" "$repo_dir"
  fi
}

download_with_archive() {
  local ref="$1"
  local repo_dir="$2"
  local archive_url="${CREATIVE_AGENT_METHODS_ARCHIVE_URL:-${DEFAULT_ARCHIVE_URL_BASE}/${ref}.tar.gz}"
  local temp_dir

  need_command curl
  need_command tar

  temp_dir="$(mktemp -d)"
  trap 'rm -rf "$temp_dir"' EXIT

  info "Downloading $PROJECT_NAME archive from $archive_url"
  curl -fsSL "$archive_url" -o "$temp_dir/source.tar.gz"
  mkdir -p "$(dirname "$repo_dir")"
  rm -rf "$repo_dir"
  mkdir -p "$repo_dir"
  tar -xzf "$temp_dir/source.tar.gz" -C "$temp_dir"

  local extracted
  extracted="$(find "$temp_dir" -mindepth 1 -maxdepth 1 -type d -name "${PROJECT_NAME}-*" | head -n 1)"
  [[ -n "$extracted" ]] || die "could not find extracted project directory"
  cp -R "$extracted"/. "$repo_dir"/
}

main() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  local target="codex"
  if [[ "$#" -gt 0 && "${1:-}" != --* ]]; then
    target="$1"
    shift
  fi

  case "$target" in
    codex|claude|opencode|openclaw|all) ;;
    *) die "unknown target: $target" ;;
  esac

  local repo_url="${CREATIVE_AGENT_METHODS_REPO:-$DEFAULT_REPO_URL}"
  local ref="${CREATIVE_AGENT_METHODS_REF:-main}"
  local install_root
  install_root="$(expand_path "${CREATIVE_AGENT_METHODS_HOME:-$HOME/.creative-agent-methods}")"

  local repo_dir="$install_root/repo"
  if [[ -n "${CREATIVE_AGENT_METHODS_SOURCE_DIR:-}" ]]; then
    repo_dir="$(expand_path "$CREATIVE_AGENT_METHODS_SOURCE_DIR")"
    [[ -d "$repo_dir" ]] || die "CREATIVE_AGENT_METHODS_SOURCE_DIR does not exist: $repo_dir"
    info "Using local source: $repo_dir"
  else
    if command -v git >/dev/null 2>&1; then
      download_with_git "$repo_url" "$ref" "$repo_dir"
    else
      download_with_archive "$ref" "$repo_dir"
    fi
  fi

  local cli="$repo_dir/bin/$PROJECT_NAME"
  [[ -f "$cli" ]] || die "CLI not found: $cli"
  chmod +x "$cli"

  if [[ "${CREATIVE_AGENT_METHODS_INSTALL_CLI:-1}" == "1" ]]; then
    "$cli" install-cli --force
  fi

  local mode="${CREATIVE_AGENT_METHODS_MODE:-copy}"
  local install_args=("--mode" "$mode")
  if [[ "${CREATIVE_AGENT_METHODS_FORCE:-1}" == "1" ]]; then
    install_args+=("--force")
  fi

  "$cli" install "$target" "${install_args[@]}" "$@"
}

main "$@"
