set -euo pipefail
export HOME="$TMPDIR/clean-home"
export XDG_CONFIG_HOME="$HOME/.config" XDG_DATA_HOME="$HOME/.local/share" XDG_CACHE_HOME="$HOME/.cache" XDG_STATE_HOME="$HOME/.local/state"
export TERM=xterm-256color
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"
test "$(git config --get user.name)" = 'REDACTED'
test "$(git config --get init.defaultBranch)" = main
nvim --headless '+lua assert(vim.g.colors_name == "everforest"); assert(vim.treesitter.language.add("nix"))' +qa
btop --version
# An isolated tmux server exercises its config and configured Zsh without
# touching an existing user's server or dotfiles.
tmux -L nixos-config-check new-session -d 'sleep 30'
trap 'tmux -L nixos-config-check kill-server 2>/dev/null || true' EXIT
test "$(tmux -L nixos-config-check show-options -gv prefix)" = C-Space
test "$(tmux -L nixos-config-check show-window-options -gv mode-keys)" = vi
tmux -L nixos-config-check list-keys -T prefix | grep -q config_files
for cmd in zsh git nvim tmux btop yazi eza zoxide ssh direnv fzf rg cmatrix fast speedtest-cli gh fastfetch fetch tldr glances; do command -v "$cmd"; done
