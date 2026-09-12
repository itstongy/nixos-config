{ ... }: {
  flake.modules.nixos.appearance = { pkgs, ... }: {
    fonts.packages = [ pkgs.dm-mono ];
    home-manager.users.tongy = {
      tongy.writableFiles = {
        ".local/state/caelestia/scheme.json" = ../assets/caelestia/scheme.json;
        ".local/state/caelestia/wallpaper/path.txt" = pkgs.writeText "wallpaper-path" "${
          ../assets/everforest-leaf.jpg
        }";
        ".config/vesktop/settings.json" = ../assets/vesktop/settings.json;
        ".config/vesktop/settings/settings.json" = ../assets/vesktop/vencord.json;
      };
      xdg.configFile = {
        "vesktop/themes/everforest.css".source = ../assets/vesktop/everforest.css;
        "vesktop/settings/quickCss.css".source = ../assets/vesktop/quickCss.css;
      };
    };
  };
}
