#!/usr/bin/env bash
# Shell environment & prerequisite verification tool with robust error handling

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/utils.sh
if [[ -f "${SCRIPT_DIR}/utils.sh" ]]; then
  source "${SCRIPT_DIR}/utils.sh"
else
  echo "[ERROR] Missing required utils library: ${SCRIPT_DIR}/utils.sh" >&2
  exit 1
fi

show_usage() {
  cat <<'EOF'
Usage: env_checker.sh [OPTIONS]

Options:
  --cmd COMMAND_LIST   Comma-separated list of required CLI commands to check
  --var VAR_LIST       Comma-separated list of required environment variables to check
  --file FILE_LIST     Comma-separated list of required files/directories to check
  -h, --help           Show this help message and exit

Exit Codes:
  0   All prerequisites passed
  1   General error or failed checks
  2   Invalid command-line arguments
EOF
}

check_commands() {
  local cmds="$1"
  local failed=0
  IFS=',' read -ra cmd_array <<< "$cmds"
  for cmd in "${cmd_array[@]}"; do
    cmd="$(echo "$cmd" | xargs)"
    if [[ -z "$cmd" ]]; then
      continue
    fi
    if command -v "$cmd" >/dev/null 2>&1; then
      log_success "Command found: $cmd ($(command -v "$cmd"))"
    else
      log_error "Missing required command: $cmd"
      failed=1
    fi
  done
  return "$failed"
}

check_vars() {
  local vars="$1"
  local failed=0
  IFS=',' read -ra var_array <<< "$vars"
  for var in "${var_array[@]}"; do
    var="$(echo "$var" | xargs)"
    if [[ -z "$var" ]]; then
      continue
    fi
    if [[ -n "${!var+x}" && -n "${!var}" ]]; then
      log_success "Environment variable set: $var"
    else
      log_error "Environment variable unset or empty: $var"
      failed=1
    fi
  done
  return "$failed"
}

check_files() {
  local files="$1"
  local failed=0
  IFS=',' read -ra file_array <<< "$files"
  for file in "${file_array[@]}"; do
    file="$(echo "$file" | xargs)"
    if [[ -z "$file" ]]; then
      continue
    fi
    if [[ -e "$file" ]]; then
      log_success "Path exists: $file"
    else
      log_error "Path not found: $file"
      failed=1
    fi
  done
  return "$failed"
}

main() {
  if [[ $# -eq 0 ]]; then
    show_usage
    exit 2
  fi

  local cmds=""
  local vars=""
  local files=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --cmd)
        [[ -n "${2:-}" ]] || die 2 "Option --cmd requires a non-empty argument."
        cmds="$2"
        shift 2
        ;;
      --var)
        [[ -n "${2:-}" ]] || die 2 "Option --var requires a non-empty argument."
        vars="$2"
        shift 2
        ;;
      --file)
        [[ -n "${2:-}" ]] || die 2 "Option --file requires a non-empty argument."
        files="$2"
        shift 2
        ;;
      -h|--help)
        show_usage
        exit 0
        ;;
      *)
        die 2 "Unknown option: $1. Use --help for usage information."
        ;;
    esac
  done

  local overall_status=0

  if [[ -n "$cmds" ]]; then
    log_info "Checking commands..."
    check_commands "$cmds" || overall_status=1
  fi

  if [[ -n "$vars" ]]; then
    log_info "Checking environment variables..."
    check_vars "$vars" || overall_status=1
  fi

  if [[ -n "$files" ]]; then
    log_info "Checking files and directories..."
    check_files "$files" || overall_status=1
  fi

  if [[ "$overall_status" -eq 0 ]]; then
    log_success "All environment checks passed successfully!"
  else
    log_error "One or more environment checks failed."
  fi

  exit "$overall_status"
}

main "$@"
