# self-config

Personal Bash, Vim, and tmux configuration files with a one-shot setup script.

## Version Check

Before running setup, ensure:

- `Vim >= 9.0.0438`
- `Node.js >= 20`
- If either version does not meet the requirement, stop setup and upgrade first.

```bash
vim --version | head -n 2
node -v
```

## Quick Setup

Run:

```bash
chmod +x ./quick_setup.sh
./quick_setup.sh
```

`quick_setup.sh` will:

1. Replace `luff` with current `$USER` in `.bashrc`, `.vimrc`, and `.tmux.conf` (in this repo)
2. Install `oh-my-bash` (skip if already installed at `~/.oh-my-bash`)
3. Clone and install `ble.sh` to `~/.local`
4. Overwrite user config files with this repo's versions:
   - `.bashrc` -> `~/.bashrc`
   - `.vimrc` -> `~/.vimrc`
   - `.tmux.conf` -> `~/.tmux.conf`
5. Install Vim plugins from `.vimrc` via `vim-plug`
6. Install tmux plugins from `.tmux.conf` via TPM

## Fish Setup

Run:

```bash
chmod +x ./install_fish.sh
./install_fish.sh
```

`install_fish.sh` will:

1. Install `fish` (supports `apt`, `dnf`, `yum`, `pacman`, `zypper`, `brew`)
   - On Ubuntu/Debian: install `software-properties-common`, add `ppa:fish-shell/release-4`, then install `fish`
2. Skip install if `fish` is already available in `PATH`
3. Verify installed fish version is strictly `> 3.4.0`
4. Exit with error if version check fails and ask you to upgrade first
5. Set default login shell to fish via `chsh -s "$(command -v fish)"` (or print manual command if it fails)
6. Print a reminder to start a new session, then run in fish shell:
   - `fish_config prompt choose informative_vcs`
   - `fish_config theme choose dracula`

## Notes

- The setup script requires `curl`, `git`, `make`, `vim`, and `tmux`.
- It performs network downloads during execution.
- Use `./quick_setup.sh --help` to view script behavior.

## Prompt  
for oh-my-bash  
``
PS1="$(clock_prompt)$spack_env$python_venv ${_omb_prompt_bold_teal}\W $(scm_prompt_char_info)${ret_status}$ ${_omb_prompt_normal}"
``
