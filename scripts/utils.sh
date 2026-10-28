#!/usr/bin/env bash
# Common error handling and logging utilities for quick-tools

set -euo pipefail

# Color support check for terminal output
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
  COLOR_RED="$(tput setaf 1)"
  COLOR_GREEN="$(tput setaf 2)"
  COLOR_YELLOW="$(tput setaf 3)"
  COLOR_BLUE="$(tput setaf 4)"
  COLOR_RESET="$(tput sgr0)"
else
  COLOR_RED=""
  COLOR_GREEN=""
  COLOR_YELLOW=""
  COLOR_RESET=""
fi

log_info() {
  printf "%s[INFO]%s %s\n" "${COLOR_BLUE}" "${COLOR_RESET}" "$*" >&2
}

log_success() {
  printf "%s[SUCCESS]%s %s\n" "${COLOR_GREEN}" "${COLOR_RESET}" "$*" >&2
}

log_warn() {
  printf "%s[WARN]%s %s\n" "${COLOR_YELLOW}" "${COLOR_RESET}" "$*" >&2
}

log_error() {
  printf "%s[ERROR]%s %s\n" "${COLOR_RED}" "${COLOR_RESET}" "$*" >&2
}

die() {
  local code=1
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    code="$1"
    shift
  fi
  log_error "$*"
  exit "$code"
}

check_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    die 127 "Required command '$cmd' is not installed or not in PATH."
  fi
}

require_file() {
  local file="$1"
  if [[ ! -e "$file" ]]; then
    die 2 "File or directory '$file' does not exist."
  fi
  if [[ ! -r "$file" ]]; then
    die 2 "File or directory '$file' is not readable."
  fi
}

register_cleanup() {
  local target="$1"
  trap 'rm -rf "$target"' EXIT INT TERM
}
