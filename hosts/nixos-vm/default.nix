{ modulesPath, lib, pkgs, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") /home/tongy/.config/nixos-private/nixos-vm/default.nix ];
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
  # Preserve the existing password in /etc/shadow; never put it in the store.
  users.mutableUsers = true;
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "26.05";
}
