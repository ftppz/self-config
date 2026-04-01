#!/usr/bin/env bash
set -euo pipefail

# Run from any location: resolve this script's directory as source dotfiles dir.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPLACE_FROM="luff"
REPLACE_TO="${USER:-}"
if [[ -z "${REPLACE_TO}" ]]; then
  REPLACE_TO="$(id -un)"
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<'EOF'
Usage:
  ./quick_setup.sh

Behavior:
  Replace keyword "luff" with current shell user from $USER
  in .bashrc, .vimrc, and .tmux.conf in this directory.
EOF
  exit 0
fi

TARGET_HOME="${HOME:-}"
PASSWD_HOME="$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f6 || true)"
if [[ -n "${PASSWD_HOME}" && -d "${PASSWD_HOME}" && -w "${PASSWD_HOME}" ]]; then
  TARGET_HOME="${PASSWD_HOME}"
fi
if [[ -z "${TARGET_HOME}" || ! -d "${TARGET_HOME}" || ! -w "${TARGET_HOME}" ]]; then
  echo "Error: cannot determine a writable home directory (HOME=${HOME:-<unset>}, passwd_home=${PASSWD_HOME:-<unset>})." >&2
  exit 1
fi

echo "[pre] Replace keyword \"${REPLACE_FROM}\" -> \"${REPLACE_TO}\" in dotfiles..."
for target in ".bashrc" ".vimrc" ".tmux.conf"; do
  file="${SCRIPT_DIR}/${target}"
  if [[ -f "${file}" ]]; then
    REPLACE_TO="${REPLACE_TO}" perl -i -pe 's/\bluff\b/$ENV{REPLACE_TO}/g' "${file}"
  else
    echo "Warning: ${file} not found, skipped replacement." >&2
  fi
done

echo "[1/5] Install oh-my-bash..."
if [[ -d "$TARGET_HOME/.oh-my-bash" ]]; then
  echo "oh-my-bash already installed, skipped."
else
  OSH="$TARGET_HOME/.oh-my-bash" HOME="$TARGET_HOME" \
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
fi

echo "[2/5] Install ble.sh..."
if [[ ! -d "${SCRIPT_DIR}/ble.sh" ]]; then
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "${SCRIPT_DIR}/ble.sh"
fi
make -C "${SCRIPT_DIR}/ble.sh" install PREFIX="$TARGET_HOME/.local"

echo "[3/5] Overwrite user config files..."
cp -f "${SCRIPT_DIR}/.bashrc" "$TARGET_HOME/.bashrc"
cp -f "${SCRIPT_DIR}/.vimrc" "$TARGET_HOME/.vimrc"

cp -f "${SCRIPT_DIR}/.tmux.conf" "$TARGET_HOME/.tmux.conf"
sed -i "s|^export OSH=.*$|export OSH='$TARGET_HOME/.oh-my-bash'|" "$TARGET_HOME/.bashrc"

echo "[4/5] Install Vim plugins from .vimrc..."
mkdir -p "$TARGET_HOME/.vim/autoload"
if [[ ! -f "$TARGET_HOME/.vim/autoload/plug.vim" ]]; then
  curl -fLo "$TARGET_HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v vim >/dev/null 2>&1; then
  if ! vim -N -E -s -u "$TARGET_HOME/.vimrc" +PlugInstall +qall; then
    echo "Warning: vim plugin installation failed, continuing." >&2
  else
    echo "Info: Vim plugins installed successfully."
    echo "Info: to enable your preferred theme, edit $TARGET_HOME/.vimrc and uncomment the colorscheme line."
  fi
else
  echo "Warning: vim not found, skipped Vim plugin installation." >&2
fi

echo "[5/5] Install tmux plugins from .tmux.conf..."
mkdir -p "$TARGET_HOME/.tmux/plugins"
if [[ ! -d "$TARGET_HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TARGET_HOME/.tmux/plugins/tpm"
fi

if command -v tmux >/dev/null 2>&1; then
  tmux start-server 2>/dev/null || true
  tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$TARGET_HOME/.tmux/plugins" 2>/dev/null || true
  "$TARGET_HOME/.tmux/plugins/tpm/bin/install_plugins" || true
else
  echo "Warning: tmux not found, skipped tmux plugin installation." >&2
fi

echo "Done."
echo "Note: run 'bash' to switch to a new shell with updated config."
