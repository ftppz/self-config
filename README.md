# self-config

Personal Bash, Vim, and tmux configuration files with a one-shot setup script.

## Files

- `.bashrc`
- `.vimrc`
- `.tmux.conf`
- `quick_setup.sh`

## Quick Setup

Run:

```bash
chmod +x ./quick_setup.sh
./quick_setup.sh
```

`quick_setup.sh` will:

1. Install `oh-my-bash`
2. Clone and install `ble.sh` to `~/.local`
3. Overwrite user config files with this repo's versions:
   - `.bashrc` -> `~/.bashrc`
   - `.vimrc` -> `~/.vimrc`
   - `.tmux.conf` -> `~/.tmux.conf`
4. Install Vim plugins from `.vimrc` via `vim-plug`
5. Install tmux plugins from `.tmux.conf` via TPM

## Notes

- The setup script requires `curl`, `git`, `make`, `vim`, and `tmux`.
- It performs network downloads during execution.
