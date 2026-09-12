{ ... }: {
  flake.modules.nixos.base = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    networking.networkmanager.enable = true;
    time.timeZone = "Australia/Brisbane";
    i18n.defaultLocale = "en_AU.UTF-8";
    users.users.tongy = {
      isNormalUser = true;
      description = "REDACTED";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
      ];
    };
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.nh.enable = true;
    services.fstrim.enable = true;
    environment.systemPackages = with pkgs; [
      nixfmt
      nix-output-monitor
      nh
      curl
      unzip
      zip
    ];
  };
}
