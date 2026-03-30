#!/usr/bin/env bash
set -euo pipefail

# Run from any location: resolve this script's directory as source dotfiles dir.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPLACE_FROM="luff"
REPLACE_TO="${1:-}"

if [[ "${REPLACE_TO}" == "-h" || "${REPLACE_TO}" == "--help" ]]; then
  cat <<'EOF'
Usage:
  ./quick_setup.sh [new_name]

Optional argument:
  new_name    Replace keyword "luff" in .bashrc, .vimrc, and .tmux.conf in this directory.
EOF
  exit 0
fi

if [[ -n "${REPLACE_TO}" ]]; then
  echo "[pre] Replace keyword \"${REPLACE_FROM}\" -> \"${REPLACE_TO}\" in dotfiles..."
  for target in ".bashrc" ".vimrc" ".tmux.conf"; do
    file="${SCRIPT_DIR}/${target}"
    if [[ -f "${file}" ]]; then
      REPLACE_TO="${REPLACE_TO}" perl -i -pe 's/\bluff\b/$ENV{REPLACE_TO}/g' "${file}"
    else
      echo "Warning: ${file} not found, skipped replacement." >&2
    fi
  done
fi

echo "[1/5] Install oh-my-bash..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

echo "[2/5] Install ble.sh..."
if [[ ! -d "${SCRIPT_DIR}/ble.sh" ]]; then
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "${SCRIPT_DIR}/ble.sh"
fi
make -C "${SCRIPT_DIR}/ble.sh" install PREFIX="$HOME/.local"

echo "[3/5] Overwrite user config files..."
cp -f "${SCRIPT_DIR}/.bashrc" "$HOME/.bashrc"
cp -f "${SCRIPT_DIR}/.vimrc" "$HOME/.vimrc"

cp -f "${SCRIPT_DIR}/.tmux.conf" "$HOME/.tmux.conf"

echo "[4/5] Install Vim plugins from .vimrc..."
mkdir -p "$HOME/.vim/autoload"
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v vim >/dev/null 2>&1; then
  vim -E -s -u "$HOME/.vimrc" +PlugInstall +qall
else
  echo "Warning: vim not found, skipped Vim plugin installation." >&2
fi

echo "[5/5] Install tmux plugins from .tmux.conf..."
mkdir -p "$HOME/.tmux/plugins"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if command -v tmux >/dev/null 2>&1; then
  tmux start-server
  tmux new-session -d -s __quick_setup_tpm "sleep 20" 2>/dev/null || true
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
  tmux kill-session -t __quick_setup_tpm 2>/dev/null || true
else
  echo "Warning: tmux not found, skipped tmux plugin installation." >&2
fi

echo "Done."
