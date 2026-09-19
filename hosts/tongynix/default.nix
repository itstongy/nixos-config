{ config, pkgs, ... }: {
  imports = [
    /home/tongy/.config/nixos-private/tongynix/hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostName = "tongynix";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  users.users.tongy.openssh.authorizedKeys.keyFiles = [ /home/tongy/.config/nixos-private/tongynix/authorized_keys ];

  services.syncthing = {
    openDefaultPorts = true;
    # Keep devices and folders paired through the local web interface.
    overrideDevices = false;
    overrideFolders = false;
  };
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

  # Use X11 for the greeter so its layout matches the NVIDIA desktop.
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.displayManager.sddm.setupScript = ''
    ${pkgs.xrandr}/bin/xrandr \
      --output DP-2 --mode 2560x1440 --pos 0x0 \
      --output DP-4 --mode 2560x1440 --rate 144 --pos 2560x0 --primary \
      --output HDMI-0 --mode 2560x1440 --same-as DP-4
  '';

  tongy.extraHyprland = ''
    hl.on("hyprland.start", function()
      hl.timer(function()
        hl.dispatch(hl.dsp.focus({ monitor = "DP-3" }))
        hl.dispatch(hl.dsp.focus({ workspace = "1" }))
      end, { timeout = 1000, type = "oneshot" })
    end)
  '';

  tongy.monitorConfig = ''
    hl.monitor({ output = "DP-3", mode = "2560x1440@144", position = "0x0", scale = 1 })
    hl.monitor({ output = "DP-2", mode = "2560x1440@59.95", position = "-2560x0", scale = 1 })
    hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@59.95", position = "auto", scale = 1, mirror = "DP-3" })
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
  '';
  tongy.dictation.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # New NixOS installation baseline; retain this after installation.
  system.stateVersion = "26.05";
}
