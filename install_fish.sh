#!/usr/bin/env bash
set -euo pipefail

MIN_FISH_VERSION="3.4.0"

version_gt() {
  local a="$1" b="$2"
  [[ "$(printf '%s\n%s\n' "$a" "$b" | sort -V | tail -n1)" == "$a" && "$a" != "$b" ]]
}

get_fish_version() {
  fish --version | awk '{print $3}'
}

get_login_shell() {
  if command -v getent >/dev/null 2>&1; then
    getent passwd "$USER" | cut -d: -f7
  else
    echo "${SHELL:-}"
  fi
}

install_fish() {
  if command -v fish >/dev/null 2>&1; then
    echo "fish already installed, skipped."
  else
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get install -y software-properties-common
      sudo add-apt-repository -y ppa:fish-shell/release-4
      sudo apt-get update
      sudo apt-get install -y fish
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y fish
    elif command -v yum >/dev/null 2>&1; then
      sudo yum install -y fish
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -Sy --noconfirm fish
    elif command -v zypper >/dev/null 2>&1; then
      sudo zypper --non-interactive install fish
    elif command -v brew >/dev/null 2>&1; then
      brew install fish
    else
      echo "Error: unsupported package manager. Please install fish manually." >&2
      exit 1
    fi
  fi

  if ! command -v fish >/dev/null 2>&1; then
    echo "Error: fish installation failed." >&2
    exit 1
  fi

  local installed_version
  installed_version="$(get_fish_version)"
  if ! version_gt "$installed_version" "$MIN_FISH_VERSION"; then
    echo "Error: fish version must be > ${MIN_FISH_VERSION}, current: ${installed_version}." >&2
    echo "Please upgrade fish, then run this script again." >&2
    exit 1
  fi

  echo "fish version check passed: ${installed_version} (> ${MIN_FISH_VERSION})"
}

set_default_login_shell_to_fish() {
  local fish_path current_login_shell
  fish_path="$(command -v fish)"
  current_login_shell="$(get_login_shell)"

  if [[ "$current_login_shell" == "$fish_path" ]]; then
    echo "default login shell already set to fish: ${fish_path}"
    return
  fi

  if ! command -v chsh >/dev/null 2>&1; then
    echo "Warning: 'chsh' not found. Set default shell manually:" >&2
    echo "  chsh -s ${fish_path}" >&2
    return
  fi

  if chsh -s "$fish_path"; then
    echo "default login shell updated to fish: ${fish_path}"
  else
    echo "Warning: failed to set default login shell automatically." >&2
    echo "Run this manually:" >&2
    echo "  chsh -s ${fish_path}" >&2
  fi
}

install_fish
set_default_login_shell_to_fish

echo "Done. Start a new session, then run in fish shell:"
echo "  fish_config prompt choose informative_vcs"
echo "  fish_config theme choose dracula"
