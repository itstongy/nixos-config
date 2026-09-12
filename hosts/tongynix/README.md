# Install the tongynix desktop

This host is ready to build for a fresh NixOS installation on the current desktop. It does not reuse or convert the existing Arch root filesystem.

## Included hardware settings

- Intel Core i7-6700K with Intel microcode and KVM support.
- NVIDIA GTX 1080 using proprietary `legacy_580` with modesetting. Newer driver branches and NVIDIA's open kernel modules do not support this card.
- Main ROG PG279Q on DP-3, 2560×1440 at 144 Hz.
- Left ASUS PB278 on DP-2, 2560×1440 at 59.95 Hz.
- Existing ext4 data disks at `/media/storage1`, `/media/storage2` and `/media/storage3`, mounted on demand by their observed UUIDs.
- UEFI systemd-boot, compressed RAM swap, and the shared desktop and Home Manager configuration.

The full system, including its NVIDIA kernel module, was successfully built in the test VM. Physical graphics and suspend remain installation checks.

Normal password login and sudo authentication apply. Dictation starts disabled. The VM's autologin, passwordless sudo and software rendering do not apply here.

## Prepare the installation

Back up the Arch home directory and any files on the system disk that you want to keep. Browser profiles, passwords and application data are not recreated by the Nix configuration. Preserve the three data disks; their filesystem UUIDs are already recorded in `hardware-configuration.nix`.

Boot a NixOS installer in UEFI mode and connect to the network. Use the installer disk tools to prepare the chosen system disk with this layout:

| Partition | Format | Filesystem label | Mount during installation |
| --- | --- | --- | --- |
| EFI system partition, 1 GiB | FAT32 | `TONGYBOOT` | `/mnt/boot` |
| Root, remaining space | ext4 | `tongynix-root` | `/mnt` |

This is an unencrypted layout with `/home` on the root filesystem. It uses zram instead of a disk swap partition and does not configure hibernation. If you choose encryption, Btrfs or separate home storage, replace `filesystems.nix` with the installer-generated filesystem and encryption declarations before installing.

Select the system disk by its model and serial in the installer. Device names such as `/dev/sda` can change, and this PC has several data disks. The labels above must be unique among connected filesystems.

After creating and labelling the target filesystems, mount them:

```sh
sudo mount /dev/disk/by-label/tongynix-root /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/TONGYBOOT /mnt/boot
findmnt --target /mnt
findmnt --target /mnt/boot
```

## Install from the flake

Use a live shell with Git and flakes available. The repository ends up at `/etc/nixos` on the installed machine.

```sh
sudo mkdir -p /mnt/etc
sudo git clone https://github.com/itstongy/nixos-config.git /mnt/etc/nixos

# Inspect the actual installation hardware without overwriting the host.
sudo nixos-generate-config --root /mnt --show-hardware-config

# Install the physical desktop host, not nixos-vm.
sudo nixos-install --flake /mnt/etc/nixos#tongynix

# Set the desktop user's password before rebooting.
sudo nixos-enter --root /mnt -c 'passwd tongy'
sudo nixos-enter --root /mnt -c 'chown -R tongy:users /etc/nixos'
```

Compare the generated hardware output with `hosts/tongynix/hardware-configuration.nix` and `filesystems.nix` before installation, especially if hardware or disk choices changed. Keep any required storage-controller or encryption modules. No new UUID is needed when using the declared labels.

After installation succeeds, reboot from the installed disk and log in as `tongy`. Check both displays, networking, audio, lock/unlock and suspend. Connector names can differ between driver versions; inspect `hyprctl monitors` and adjust `tongy.monitorConfig` if needed. Pair Syncthing and authenticate Tailscale separately, then restore personal data.

## Update this machine

```sh
cd /etc/nixos
git pull --ff-only
nix flake check
nix build .#checks.x86_64-linux.caelestia-config .#checks.x86_64-linux.portable --no-link
sudo nixos-rebuild test --flake .#tongynix
# Once the desktop checks pass:
sudo nixos-rebuild switch --flake .#tongynix
```

The installation baseline is `system.stateVersion = "26.05"`. Keep it unchanged for normal updates. System builds can be checked in the VM, but physical NVIDIA behaviour and installation must be tested on this desktop. Never switch the VM to this host.

References: [NixOS installation manual](https://nixos.org/manual/nixos/stable/) and [NVIDIA configuration](https://wiki.nixos.org/wiki/NVIDIA).
