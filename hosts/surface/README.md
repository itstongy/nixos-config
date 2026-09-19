# Surface Pro 4

Host name: `tongy-surface`. The flake target remains `surface`. Keep this Git
checkout at `/etc/nixos`, owned by `tongy`.

This host imports the Surface's original `hardware-configuration.nix` unchanged,
including its ext4 root, EFI partition and swap UUIDs. It preserves systemd-boot,
and `system.stateVersion = "26.05"` from the initial
installation. It uses the shared Hyprland desktop with 1.5x scaling on `eDP-1`
and the standard Adwaita cursor.
The existing user password remains on the machine. SSH stays enabled and the Mac's
public key is declared; no private keys or passwords belong in this repository.

## SSH access

The Surface's dedicated private key is `~/.ssh/surface_ed25519`; only its public
half is tracked here. `ssh-config` provides the existing machine aliases using
that key. `authorized_keys` retains the trusted machine/mobile/security-key set
already used on tongylab. Comet receives the Surface's public key only and has no
access back to the Surface.

From the Mac, tongylab or Linux desktop, use `ssh surface`. This connects to
`tongy@REDACTED` over Tailscale. From the Surface, use `ssh mac`, `ssh lab`,
`ssh linux`, or `ssh comet`. These directions were verified during setup.

Asahi and petersbirds were offline during setup. Their aliases exist on the
Surface, but its public key still needs installing there, and their SSH config
needs the `surface` alias. Asahi's existing public key is already trusted by the
Surface. The copied `lab-root` alias is not verified: direct root login was also
denied from the Mac, so use `ssh lab` and its existing sudo workflow.

Documents syncs with the Mac and tongylab over Tailscale. `documents.stignore`
copies the existing Documents exclusions, including `/09_SECONDBRAIN`; Obsidian
Sync owns the vault. Peer device identities are public, but Syncthing API keys and
device private keys must never be committed. Pairing must also be accepted on peers.

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
sudo nixos-rebuild switch --flake .#surface
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
sudo nixos-rebuild build --flake .#surface
sudo nixos-rebuild switch --flake .#surface
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
sudo nixos-rebuild build --flake .#surface
sudo nixos-rebuild switch --flake .#surface
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
