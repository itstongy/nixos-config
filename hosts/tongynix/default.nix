{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostName = "tongynix";
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # GTX 1080 is Pascal: newer driver branches and open kernel modules
  # do not support it. Keep the maintained legacy branch explicit.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  tongy.monitorConfig = ''
    hl.monitor({ output = "DP-3", mode = "2560x1440@144", position = "0x0", scale = 1 })
    hl.monitor({ output = "DP-2", mode = "2560x1440@59.95", position = "-2560x0", scale = 1 })
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
  '';
  tongy.dictation.enable = false;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # New NixOS installation baseline; retain this after installation.
  system.stateVersion = "26.05";
}
