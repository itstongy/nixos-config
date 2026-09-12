{ ... }: {
  flake.modules.nixos.integration = { pkgs, ... }: {
    xdg.mime.defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/plain" = "tongy-editor.desktop";
      "text/markdown" = "tongy-editor.desktop";
      "application/json" = "tongy-editor.desktop";
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
    };
    environment.systemPackages = [
      (pkgs.makeDesktopItem {
        name = "tongy-editor";
        desktopName = "Neovim";
        exec = "ghostty --class=org.tongy.nvim -e nvim %F";
        icon = "nvim";
        categories = [
          "Development"
          "TextEditor"
        ];
      })
    ];
    systemd.user.services.clipboard-history = {
      description = "Collect clipboard history for Caelestia";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
