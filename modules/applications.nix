{ inputs, config, ... }: {
  flake.modules.nixos.applications = { pkgs, ... }: {
    home-manager.users.tongy.home.packages = with pkgs; [
      inputs.zen.packages.${stdenv.hostPlatform.system}.beta
      config.flake.packages.${stdenv.hostPlatform.system}.helium
      config.flake.packages.${stdenv.hostPlatform.system}.chatgpt
      obsidian
      bitwarden-desktop
      vesktop
      spotify
      localsend
      nautilus
      file-roller
      imv
      mpv
      zathura
    ];
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    hardware.graphics.enable32Bit = true;
    services.tailscale.enable = true;
    services.syncthing = {
      enable = true;
      user = "tongy";
      dataDir = "/home/tongy";
      configDir = "/home/tongy/.local/state/syncthing";
    };
  };
}
