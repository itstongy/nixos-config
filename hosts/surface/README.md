# Surface Pro 4

Host name: `tongy-surface`. The flake target remains `surface`. Keep this Git
checkout at `/etc/nixos`, owned by `tongy`.

Machine-specific settings live outside Git in
`/home/tongy/.config/nixos-private/surface/`. Its `default.nix` imports the
installer-generated `hardware-configuration.nix` and declares the local SSH
access list, SSH aliases, Syncthing peers, Documents exclusions and browser profile
settings. Preserve this directory in your private backups. Never put it in the
public repository. The directory is required for evaluation and rebuilds use
`--impure` to read it.

The shared desktop uses Hyprland, 1.5x scaling and the Adwaita cursor. Passwords,
SSH private keys and service credentials remain in their normal local stores.
Use `ssh surface` from a configured peer. Device addresses and access lists are
managed locally.

The keyboard tray menu offers Show keyboard and Hide keyboard. It launches wvkbd
only when requested and starts with the graphical session. LocalSend's incoming
TCP and UDP port 53317 is allowed; Syncthing TCP 22000 is allowed on Tailscale only.

The pinned `nixos-hardware` Surface Pro Intel module supplies the linux-surface
kernel and enables `iptsd` for touchscreen and pen input. The first kernel build
can take a long time. Reboot after building to load the driver; touchscreen and
pen operation still need to be checked on the device.

The login greeter uses X11; Hyprland still uses Wayland. During the first boot the
panel remained black even though a screenshot showed the complete login screen.
Turning the eDP output off and on restored the display. `i915.enable_psr=0` disables
Panel Self Refresh as a targeted workaround to test on the next boot. The cause is
not yet confirmed; disabling this power-saving feature may increase battery use.

## Pull configuration changes

```sh
cd /etc/nixos
git pull --ff-only
sudo nixos-rebuild switch --impure --flake .#surface
```

Reboot after kernel updates to use the new kernel. A desktop session may need a
logout and login after desktop configuration changes.

## Update packages and NixOS inputs

`git pull` fetches repository changes. `nix flake update` advances the dependency
versions recorded in `flake.lock`; these are separate operations.

```sh
cd /etc/nixos
git pull --ff-only
nix flake update
sudo nixos-rebuild build --impure --flake .#surface
sudo nixos-rebuild switch --impure --flake .#surface
git add flake.lock
git commit -m "Update flake inputs"
git push
```

The lock file is shared by every host in this repository. Keep `system.stateVersion`
and `home.stateVersion` unchanged during routine upgrades.

## Save configuration edits

```sh
cd /etc/nixos
git status
git add hosts/surface
sudo nixos-rebuild build --impure --flake .#surface
sudo nixos-rebuild switch --impure --flake .#surface
git commit -m "Update Surface configuration"
git push
```

Stage any other files you edited explicitly before committing. Newly created Nix
files must be added to Git before the flake can see them. Do not commit secrets.
Pushing over HTTPS requires GitHub authentication on the Surface. Once signed in
using `gh auth login`, run `gh auth setup-git`.

## Recovery

```sh
sudo nixos-rebuild switch --rollback
```

If boot fails, select an earlier NixOS generation in the systemd-boot menu. Rolling
back the running system does not undo Git edits or a changed `flake.lock`.
The original installer-generated configuration was backed up separately under
`/etc/nixos.before-flake-<timestamp>` during migration.
