#!/usr/bin/env bash
# Run as tongy inside the activated NixOS desktop, from the repository root.
set -euo pipefail
systemctl is-active --quiet home-manager-tongy.service
for unit in clipboard-history desktop-polkit vicinae; do
  systemctl --user is-active --quiet "$unit.service"
  [[ "$(systemctl --user show "$unit.service" -p FragmentPath --value)" == "$HOME/.config/systemd/user/"* ]]
done
for file in hypr/hyprland.lua hypr/lua gtk-3.0/settings.ini gtk-4.0/settings.ini vesktop/themes/everforest.css vesktop/settings/quickCss.css; do
  [[ "$(readlink "$HOME/.config/$file")" == /nix/store/*-home-manager-files/* ]]
done
for file in .config/caelestia/shell.json .local/state/caelestia/scheme.json .local/state/caelestia/wallpaper/path.txt .config/vicinae/settings.json .config/vesktop/settings.json .config/vesktop/settings/settings.json; do
  [[ -f "$HOME/$file" && ! -L "$HOME/$file" && -w "$HOME/$file" ]]
done
cmp assets/caelestia/shell.json "$HOME/.config/caelestia/shell.json"
cmp assets/vesktop/vencord.json "$HOME/.config/vesktop/settings/settings.json"
[[ -r "$(cat "$HOME/.local/state/caelestia/wallpaper/path.txt")" ]]
for app in ghostty zsh git tmux nvim btop zen-beta helium chatgpt vicinae caelestia take-screenshot ocr-screenshot; do
  test -x "/etc/profiles/per-user/$USER/bin/$app"
done
grep -q 'gtk-theme-name=adw-gtk3-dark' "$HOME/.config/gtk-3.0/settings.ini"
grep -q 'text/plain=tongy-editor.desktop' "$HOME/.config/mimeapps.list"
for desktop in tongy-editor zen-beta helium chatgpt; do
  test -r "/etc/profiles/per-user/$USER/share/applications/$desktop.desktop"
done
printf 'Home Manager runtime checks passed.\n'
