#!/usr/bin/env bash
set -euo pipefail

install_fish() {
  if command -v fish >/dev/null 2>&1; then
    echo "fish already installed, skipped."
    return
  fi

  if command -v apt-get >/dev/null 2>&1; then
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
}

install_fisher() {
  if ! command -v fish >/dev/null 2>&1; then
    echo "Error: fish is not installed." >&2
    exit 1
  fi

  if fish -c 'functions -q fisher' >/dev/null 2>&1; then
    echo "fisher already installed, skipped."
    return
  fi

  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
}

install_fish_dracula_theme() {
  if ! command -v fish >/dev/null 2>&1; then
    echo "Error: fish is not installed." >&2
    exit 1
  fi

  fish -c 'fisher install dracula/fish'
}

install_fish
install_fisher
install_fish_dracula_theme

echo "Done."
