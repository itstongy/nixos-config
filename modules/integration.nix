{ ... }: {
  flake.modules.nixos.integration = { pkgs, ... }: {
    home-manager.users.tongy.xdg.mimeApps.defaultApplications = {
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
    home-manager.users.tongy.xdg.mimeApps.enable = true;
    home-manager.users.tongy.xdg.desktopEntries.tongy-editor = {
      name = "Neovim";
      exec = "ghostty --class=org.tongy.nvim -e nvim %F";
      icon = "nvim";
      categories = [
        "Development"
        "TextEditor"
      ];
      terminal = false;
    };
    home-manager.users.tongy.systemd.user.services.clipboard-history = {
      Unit.Description = "Collect clipboard history for Caelestia";
      Install.WantedBy = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Unit.PartOf = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
