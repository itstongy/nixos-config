{ ... }: {
  flake.modules.nixos.compositor = { pkgs, config, ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "hyprland-uwsm";
    };
    hardware.graphics.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    security.polkit.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    hardware.bluetooth.enable = true;
    systemd.user.services.desktop-polkit = {
      description = "Desktop authentication agent";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.Restart = "on-failure";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    };
    security.pam.services.hyprlock = { };
    services.gnome.gnome-keyring.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    programs.dconf.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      noto-fonts
      atkinson-hyperlegible
      noto-fonts-color-emoji
      material-symbols
      rubik
    ];
    environment.systemPackages = with pkgs; [
      caelestia-shell
      caelestia-cli
      quickshell
      kdePackages.polkit-kde-agent-1
      hyprlock
      hypridle
      wl-clipboard
      cliphist
      grim
      slurp
      libnotify
      wiremix
      playerctl
      pulseaudio
      brightnessctl
      bluetui
      networkmanagerapplet
      papirus-icon-theme
      adw-gtk3
    ];
    environment.etc."xdg/gtk-3.0/settings.ini".text =
      "[Settings]\ngtk-theme-name=adw-gtk3-dark\ngtk-icon-theme-name=Papirus-Dark\ngtk-font-name=Atkinson Hyperlegible 11\n";
    environment.etc."xdg/gtk-4.0/settings.ini".text =
      "[Settings]\ngtk-theme-name=adw-gtk3-dark\ngtk-icon-theme-name=Papirus-Dark\n";
    tongy.settings = {
      ".config/hypr/hyprland.lua".source = pkgs.writeText "hyprland.lua" (
        builtins.readFile ../assets/hypr/hyprland.lua
        + "\n"
        + config.tongy.monitorConfig
        + "\n"
        + config.tongy.extraHyprland
      );
      ".config/hypr/lua".source = ../assets/hypr/lua;
      ".config/caelestia/shell.json" = {
        source = ../assets/caelestia/shell.json;
        writable = true;
      };
      ".config/gtk-3.0/settings.ini".source =
        pkgs.writeText "gtk3.ini"
          config.environment.etc."xdg/gtk-3.0/settings.ini".text;
      ".config/gtk-4.0/settings.ini".source =
        pkgs.writeText "gtk4.ini"
          config.environment.etc."xdg/gtk-4.0/settings.ini".text;
    };
  };
}
