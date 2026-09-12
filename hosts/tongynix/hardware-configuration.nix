# Hardware observed on the Arch desktop. This is not installer-generated.
{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  # Data disks keep the same mountpoints and UUIDs across reinstallations.
  # Missing disks time out without blocking startup.
  fileSystems =
    builtins.mapAttrs
      (_: uuid: {
        device = "/dev/disk/by-uuid/${uuid}";
        fsType = "ext4";
        options = [
          "noatime"
          "nofail"
          "x-systemd.automount"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=30s"
          "x-gvfs-show"
        ];
      })
      {
        "/media/storage1" = "6fd2fddf-fba6-4d21-8de4-492b47f05817";
        "/media/storage2" = "3589cd40-40f7-425e-b193-2ef21fb27764";
        "/media/storage3" = "136eafeb-53ef-42ec-a99b-668b55c5c81d";
      };
}
