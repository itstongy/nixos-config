{ modulesPath, lib, pkgs, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  # Interpreter for the host-side clipboard bridge agent.
  environment.systemPackages = [ pkgs.python3 ];
  nixpkgs.hostPlatform = "x86_64-linux";
  tongy.dictation.enable = false;
  services.displayManager.autoLogin = {
    enable = true;
    user = "tongy";
  };
  tongy.monitorConfig = ''hl.monitor({ output = "", mode = "1920x1080@60", position = "auto", scale = 1 })'';
  tongy.ghosttySoftwareRendering = true;
  nix.settings.max-jobs = lib.mkForce 1;
  environment.etc."mpv/mpv.conf".text = "gpu-api=opengl\nhwdec=no\n";
  networking.hostName = "nixos-vm";
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "ahci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    configurationLimit = 10;
  };
  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200"
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a10589a8-c423-4fdc-83e5-c957f7f66c33";
    fsType = "ext4";
  };
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  users.users.tongy.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFwy+DL/M8OQAHPm/ZaIeeKuTCx5pcQsJ60Fk8YStnn nixos-vm-local"
  ];
  # Preserve the existing password in /etc/shadow; never put it in the store.
  users.mutableUsers = true;
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "26.05";
}
