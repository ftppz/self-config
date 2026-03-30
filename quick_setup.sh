#!/usr/bin/env bash
set -euo pipefail

# Run from any location: resolve this script's directory as source dotfiles dir.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/3] Install oh-my-bash..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

echo "[2/3] Install ble.sh..."
if [[ ! -d "${SCRIPT_DIR}/ble.sh" ]]; then
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "${SCRIPT_DIR}/ble.sh"
fi
make -C "${SCRIPT_DIR}/ble.sh" install PREFIX="$HOME/.local"

echo "[3/3] Overwrite user config files..."
cp -f "${SCRIPT_DIR}/.bashrc" "$HOME/.bashrc"
cp -f "${SCRIPT_DIR}/.vimrc" "$HOME/.vimrc"

cp -f "${SCRIPT_DIR}/.tmux.conf" "$HOME/.tmux.conf"

echo "Done."
