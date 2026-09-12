# NixOS desktop

My daily-driver configuration, tested in a QEMU VM. Pinned nixos-unstable, dendritic flake-parts modules and portable nix-wrapper-modules packages. No Home Manager, Hjem or bootstrap script.

Currently targets x86_64 Linux. The portable packages also work on another x86_64 Linux distribution with Nix installed. macOS and ARM are not tested targets.

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

Hyprland + Caelestia, Vicinae, Ghostty, Zen, Helium, Steam + Proton GE, Vesktop, Yazi, SSH, ChatGPT desktop, Obsidian, Bitwarden, LocalSend, GNOME Files, Syncthing, mpv, Zathura, Neovim, btop, Spotify and Tailscale. Screenshot/OCR and clipboard integration are included. GTK/Papirus and Everforest appearance are configured.

No alternative desktops/launchers, Hermes, Prism, F1top, radar extensions, broad language toolchains or host-inventory packages are installed by the core profile. The VM's existing application data is not deleted when a package is removed.

## Apply the NixOS configuration

```sh
git clone https://github.com/itstongy/nixos-config.git
cd nixos-config
nix flake check
sudo nixos-rebuild switch --flake .#YOUR_HOST
```

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
- `modules/settings.nix` uses NixOS activation to install the declared user settings. Read-only configurations are store symlinks. Caelestia, Vicinae and Vesktop need writable settings, so activation installs their declared contents again on every switch. GUI edits to those managed files are temporary. Put lasting changes in this repository.
- `assets/` contains the configuration sources referenced by Nix, not an independent dotfile installation system. JSON files are used where the application already has a JSON schema; Nix owns their deployment.
- `hosts/` contains hardware, boot, monitor and VM-specific settings. The portable tools have no dependency on these definitions.

Existing ordinary files replaced by store links are renamed with a `.before-nixos.<timestamp>` suffix. Writable managed settings are replaced on activation. Accounts, cookies, SSH keys, notes, Steam libraries, Syncthing identity and Tailscale credentials are not managed or included in this repository. Sign in or restore those separately. Restart an application after switching if it caches its settings.

## Dictation

`modules/dictation.nix` declares `tongy.dictation.enable`, disabled by default. Enabling it installs the pinned VoxType model, service and Super+Ctrl+X binding. Its recording service is skipped in VMs. For supported physical GPUs, `tongy.dictation.vulkan = true` enables a Vulkan build. Microphone/GPU operation must be tested on that hardware.

## Updates and recovery

```sh
git pull --ff-only
nix flake check
sudo nixos-rebuild switch --flake .#YOUR_HOST

# Deliberately update upstream inputs:
nix flake update
nix flake check
sudo nixos-rebuild switch --flake .#YOUR_HOST
```

ChatGPT and Helium are fixed-version, fixed-hash upstream packages in `custom-apps.nix`; update their version/hash together. The Vesktop theme is stored locally with its upstream licenses. Neovim plugins are provided by pinned nixpkgs, with runtime downloads disabled.

Use `sudo nixos-rebuild switch --rollback` or select an earlier generation in GRUB. Do not change `system.stateVersion` for a normal package update.

The current VM uses 1920×1080 and software Ghostty rendering. Its host-side QEMU launcher and clipboard bridge are machine tooling outside this repository. The previously reported mouse-modifier issue is not established as permanently fixed.

## References

- [flake-parts modules](https://flake.parts/options/flake-parts-modules.html)
- [nix-wrapper-modules](https://github.com/nix-community/nix-wrapper-modules)
- [Dendritic pattern](https://github.com/mightyiam/dendritic)

The system24 CSS snapshot is from `refact0r/system24` at `07760bedf8642698a4ab12ca4eb8a96ff31d91ea`, including midnight-discord CSS at `85dd67148cbbbfa027cb091e41a479a16ab16a65`. Remote font/decorative asset requests were removed in favour of the packaged DM Mono font. Licenses are in `assets/vesktop/`.
