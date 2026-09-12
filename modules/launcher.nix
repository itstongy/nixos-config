{ ... }: {
  flake.modules.nixos.launcher = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vicinae ];
    systemd.user.services.vicinae = {
      path = [ "/run/current-system/sw" ];
      description = "Vicinae launcher";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.vicinae}/bin/vicinae server --replace";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
    tongy.settings.".config/vicinae/settings.json" = {
      writable = true;
      source = pkgs.writeText "vicinae.json" (
        builtins.toJSON {
          theme.dark.name = "nord";
          telemetry.system_info = false;
          launcher_window.opacity = 0.5;
          favorites = [ "clipboard:history" ];
          providers.applications.entrypoints = {
            vesktop.alias = "discord";
            chatgpt.alias = "chatgpt";
          };
        }
      );
    };
  };
}
