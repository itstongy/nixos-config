{ inputs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  networking.hostName = "surface";
  # LocalSend discovery and incoming transfers.
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
  # Test workaround for a black internal panel restored by an output reset.
  boot.kernelParams = lib.mkAfter [ "i915.enable_psr=0" ];
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
  services.xserver.enable = true;
  # Keep the X11 greeter used during recovery; Hyprland still uses Wayland.
  services.displayManager.sddm.wayland.enable = false;
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
