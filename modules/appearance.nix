{ ... }: {
  flake.modules.nixos.appearance = { pkgs, ... }: {
    fonts.packages = [ pkgs.dm-mono ];
    environment.etc."xdg/caelestia/wallpaper.jpg".source = ../assets/everforest-leaf.jpg;
    tongy.settings = {
      ".local/state/caelestia/scheme.json" = {
        source = ../assets/caelestia/scheme.json;
        writable = true;
      };
      ".local/state/caelestia/wallpaper/path.txt" = {
        source = pkgs.writeText "wallpaper-path" "/etc/xdg/caelestia/wallpaper.jpg";
        writable = true;
      };
      ".config/vesktop/settings.json" = {
        source = ../assets/vesktop/settings.json;
        writable = true;
      };
      ".config/vesktop/settings/settings.json" = {
        source = ../assets/vesktop/vencord.json;
        writable = true;
      };
      ".config/vesktop/themes/everforest.css".source = ../assets/vesktop/everforest.css;
      ".config/vesktop/settings/quickCss.css".source = ../assets/vesktop/quickCss.css;
    };
  };
}
