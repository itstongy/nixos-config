{ inputs, config, ... }: {
  perSystem = { pkgs, ... }: {
    packages.btop = inputs.wrappers.wrappers.btop.wrap {
      inherit pkgs;
      settings = builtins.fromJSON (builtins.readFile ../assets/btop.json);
      themes.everforest-dark-medium = ../assets/everforest-dark-medium.theme;
    };
  };
  flake.modules.nixos.activity = { pkgs, ... }: {
    home-manager.users.tongy.home.packages = [
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.btop
    ];
  };
}
