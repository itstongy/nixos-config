{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "surface";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  users.users.tongy.openssh.authorizedKeys.keys = [
    "REDACTED"
  ];

  # Preserve settings selected during the Surface's graphical installation.
  services.xserver.xkb.layout = "au";
  services.printing.enable = true;
  services.pipewire.alsa.support32Bit = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # 2736x1824 internal display; external displays retain their preferred mode.
  tongy.monitorConfig = ''
    hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
  '';

  # Bound build concurrency on this 8GB machine.
  nix.settings = {
    max-jobs = 2;
    cores = 2;
  };

  # Preserve the original installation baseline across future upgrades.
  system.stateVersion = "26.05";
}
