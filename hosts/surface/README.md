# Surface Pro 4

Host name: `surface`. Keep this Git checkout at `/etc/nixos`, owned by `tongy`.

This host imports the Surface's original `hardware-configuration.nix` unchanged,
including its ext4 root, EFI partition and swap UUIDs. It preserves systemd-boot,
the latest-kernel selection and `system.stateVersion = "26.05"` from the initial
installation. It uses the shared Hyprland desktop with 2x scaling on `eDP-1`.
The existing user password remains on the machine. SSH stays enabled and the Mac's
public key is declared; no private keys or passwords belong in this repository.

The standard kernel boots this device. Touchscreen and pen support have not been
validated; this host does not yet add the linux-surface kernel or iptsd.

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
