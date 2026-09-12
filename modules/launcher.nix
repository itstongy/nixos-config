{ ... }: {
  flake.modules.nixos.launcher = { pkgs, ... }: {
    home-manager.users.tongy.home.packages = [ pkgs.vicinae ];
    home-manager.users.tongy.systemd.user.services.vicinae = {
      Unit.Description = "Vicinae launcher";
      Install.WantedBy = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Unit.PartOf = [ "graphical-session.target" ];
      Service = {
        Environment = "PATH=/etc/profiles/per-user/tongy/bin:/run/current-system/sw/bin";
        ExecStart = "${pkgs.vicinae}/bin/vicinae server --replace";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
    home-manager.users.tongy.tongy.writableFiles.".config/vicinae/settings.json" =
      pkgs.writeText "vicinae.json"
        (
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
}
