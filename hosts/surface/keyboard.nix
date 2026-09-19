{ pkgs, ... }:
let
  python = pkgs.python3.withPackages (p: [ p.pyside6 ]);
  tray = pkgs.writeShellScriptBin "surface-keyboard" ''
    export QT_QPA_PLATFORM=xcb
    exec ${python}/bin/python ${./keyboard.py} ${pkgs.wvkbd}/bin/wvkbd-mobintl
  '';
in
{
  system.build.surfaceKeyboardTray = tray;
  home-manager.users.tongy = {
    home.packages = [ tray pkgs.wvkbd ];
    systemd.user.services.surface-keyboard = {
      Unit = {
        Description = "On-screen keyboard tray menu";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${tray}/bin/surface-keyboard";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
