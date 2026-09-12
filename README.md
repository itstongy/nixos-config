# NixOS desktop

My daily-driver configuration, tested in a QEMU VM. Pinned nixos-unstable, dendritic flake-parts modules and portable nix-wrapper-modules packages. Home Manager owns the user desktop configuration and is applied with the NixOS rebuild.

Currently targets x86_64 Linux. The portable packages also work on another x86_64 Linux distribution with Nix installed. macOS and ARM are not tested targets.

Read the complete [desktop installation and operations guide](docs/desktop-guide.html) for machine setup, daily changes, recovery and the configuration map.

## Use the tools without installing the desktop

Enter the configured Zsh shell, including the CLI tools:

```sh
nix run github:itstongy/nixos-config#shell
```

Or add the tools to a temporary shell, run one application, or install the CLI bundle in your Nix profile:

```sh
nix shell github:itstongy/nixos-config#cli
nix run github:itstongy/nixos-config#neovim
nix run github:itstongy/nixos-config#ghostty
nix profile add github:itstongy/nixos-config#cli
```

The CLI bundle contains configured Zsh/Powerlevel10k, tmux, Git, Neovim/LazyVim and btop, plus Yazi, eza, zoxide, SSH, direnv, fzf, ripgrep, fd and basic utilities. Wrappers carry their settings in the Nix store; they do not install dotfiles into the host home directory. History, editor state and caches are still writable. Use a Nerd Font in the host terminal for icons.

Project environments are separate from the desktop:

```sh
nix develop github:itstongy/nixos-config#python
nix develop github:itstongy/nixos-config#node
nix develop github:itstongy/nixos-config#rust
nix develop github:itstongy/nixos-config#nix
```

The default devShell contains the CLI suite. `nix develop ... --command zsh` uses the configured shell. Real projects should declare their own dependencies and locks; these environments are convenient starting points.

## Core desktop

Hyprland + Caelestia, Vicinae, Ghostty, Zen, Helium, Steam + Proton GE, Vesktop, Yazi, SSH, ChatGPT desktop, Obsidian, Bitwarden, LocalSend, GNOME Files, Syncthing, mpv, Zathura, Neovim, btop, Spotify and Tailscale. Screenshot/OCR and clipboard integration are included. Dark mode is declared for GTK, libadwaita, desktop portals and Qt, alongside Papirus icons and the Everforest GTK 3/4 color overrides used by Nautilus and other GTK apps.

No alternative desktops/launchers, Hermes, Prism, F1top, radar extensions, broad language toolchains or host-inventory packages are installed by the core profile. The VM's existing application data is not deleted when a package is removed.

## Apply the NixOS configuration

Keep the flake repository at `/etc/nixos` on each installed machine, owned by your user. If it is already cloned there, just `cd /etc/nixos` and pull. For an existing installation, preserve its generated configuration first. If `/etc/nixos.before-flake` exists, choose another backup name before running these commands.

```sh
# Run once on an existing NixOS installation.
# Stop if /etc/nixos is already this repository.
# Keep the original generated configuration as a backup.
sudo mv -T --no-clobber /etc/nixos /etc/nixos.before-flake
sudo install -d -o "$(id -un)" -g "$(id -gn)" /etc/nixos
git clone https://github.com/itstongy/nixos-config.git /etc/nixos
cd /etc/nixos
nix flake check
nix build .#checks.x86_64-linux.caelestia-config .#checks.x86_64-linux.portable --no-link
sudo nixos-rebuild switch --flake .#YOUR_HOST
```

[`tongynix`](hosts/tongynix/README.md) is the physical desktop host, prepared for a fresh UEFI installation with an ext4 root labelled `tongynix-root` and a FAT32 EFI partition labelled `TONGYBOOT`. Its host guide contains the installation steps and captured hardware.

`nixos-vm` is only for the existing VM. It contains that VM's filesystem UUID, virtual graphics, bootloader and local SSH public key. Do not use it as a new physical machine's host definition.

For a new NixOS machine, add `hosts/<hostname>/default.nix` and its generated hardware configuration. Every directory under `hosts/` becomes a flake host automatically and imports the same desktop profile. Preserve the new installation's bootloader configuration and `system.stateVersion`.

```nix
# hosts/my-pc/default.nix
{ ... }: {
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "my-pc";
  # Copy the bootloader settings and system.stateVersion from this
  # machine's generated configuration. Configure its physical GPU here.
  tongy.dictation.enable = true; # optional
}
```

Stage new host files with `git add hosts/my-pc` so flakes can see them, then run `sudo nixos-rebuild switch --flake .#my-pc`. A fresh disk still requires the standard NixOS installation and hardware configuration. The shared user is `tongy`; set its password on the new machine. Autologin and passwordless sudo are confined to the VM.

## Configuration ownership

- `modules/flake.nix` assembles the explicit desktop profile from named `flake.modules.nixos` features. `nixosModules` exports those same modules for reuse.
- `modules/wrappers.nix`, `editor.nix` and `activity.nix` own portable application settings. `portable.nix` provides the CLI bundle, shell, devShells and clean-home check.
- `modules/applications.nix` is the core application/service list. `desktop.nix`, `launcher.nix`, `integration.nix` and `scripts.nix` configure the desktop and its supporting tools.
- `modules/settings.nix` integrates Home Manager for `tongy`. The feature modules contribute user packages, GTK settings, MIME defaults, desktop entries and user services through `home-manager.users.tongy`. `xdg.configFile` owns read-only desktop files.
- Caelestia, Vicinae and Vesktop need writable settings. The small `tongy.writableFiles` Home Manager option copies those declared files on activation. GUI edits to them remain temporary. Put lasting changes in this repository.
- Portable wrappers remain independent of Home Manager. The desktop installs them through `home.packages`; the flake packages and development shells continue to work without activation. Hardware, login, audio, networking and system services remain in NixOS.
- `assets/` contains the configuration sources referenced by Nix, not an independent dotfile installation system. JSON files are used where the application already has a JSON schema; Nix owns their deployment.
- `hosts/` contains hardware, boot, monitor and VM-specific settings. The portable tools have no dependency on these definitions.

A migration step backs up the previous configuration’s store links before Home Manager takes ownership. Home Manager backs up conflicting ordinary files with a `.before-home-manager` suffix and numbered backups on repeated conflicts. Removing a managed file declaration lets Home Manager remove its owned link on the next activation. Writable managed settings are replaced on activation. Accounts, cookies, private SSH keys, notes, Steam libraries, Syncthing identity and Tailscale credentials are not managed or included in this repository. The physical host declares its authorized public SSH keys. Sign in or restore those separately. Restart an application after switching if it caches its settings.

## Dictation

`modules/dictation.nix` declares `tongy.dictation.enable`, disabled by default. Enabling it installs the pinned VoxType model, service and Super+Ctrl+X binding. Its recording service is skipped in VMs. For supported physical GPUs, `tongy.dictation.vulkan = true` enables a Vulkan build. Microphone/GPU operation must be tested on that hardware.

## Updates and recovery

```sh
git pull --ff-only
nix flake check
nix build .#checks.x86_64-linux.caelestia-config .#checks.x86_64-linux.portable --no-link
sudo nixos-rebuild switch --flake .#YOUR_HOST

# Deliberately update upstream inputs:
nix flake update
nix flake check
nix build .#checks.x86_64-linux.caelestia-config .#checks.x86_64-linux.portable --no-link
sudo nixos-rebuild switch --flake .#YOUR_HOST
```

Zen uses `zen-browser-flake`, Helium uses `schembriaiden/helium-browser-nix-flake`, and ChatGPT uses Numtide’s `llm-agents.nix` package of the official Linux app. `modules/custom-apps.nix` only re-exports the maintained Helium and ChatGPT packages. Their versions and source hashes come from the locked flake inputs. Update them with `nix flake update zen helium llm-agents`, then build and test before switching. The Vesktop theme is stored locally with its upstream licenses. Neovim plugins are provided by pinned nixpkgs, with runtime downloads disabled.

Use `sudo nixos-rebuild switch --rollback` or select an earlier generation in GRUB. Do not change `system.stateVersion` or `home.stateVersion` for a normal package update. Home Manager runs as `home-manager-tongy.service`; inspect that service if user activation fails. No separate `home-manager switch` is needed. `checks.caelestia-config` loads the declared JSON using the pinned Caelestia plugin and fails on unknown options; the old `bar.status` and `bar.workspaces.displayType` options have been migrated. After activation in the desktop session, run `bash tests/home-manager.sh` as `tongy` to check file ownership, writable settings, services and application availability.

The current VM uses 1920×1080 and software Ghostty rendering. Its host-side QEMU launcher and clipboard bridge are machine tooling outside this repository. The previously reported mouse-modifier issue is not established as permanently fixed.

## References

- [flake-parts modules](https://flake.parts/options/flake-parts-modules.html)
- [nix-wrapper-modules](https://github.com/nix-community/nix-wrapper-modules)
- [Dendritic pattern](https://github.com/mightyiam/dendritic)

The system24 CSS snapshot is from `refact0r/system24` at `07760bedf8642698a4ab12ca4eb8a96ff31d91ea`, including midnight-discord CSS at `85dd67148cbbbfa027cb091e41a479a16ab16a65`. Remote font/decorative asset requests were removed in favour of the packaged DM Mono font. Licenses are in `assets/vesktop/`.
