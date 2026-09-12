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
    home-manager.users.tongy.systemd.user.services.desktop-polkit = {
      Unit.Description = "Desktop authentication agent";
      Unit.After = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ];
      Unit.PartOf = [ "graphical-session.target" ];
      Service.Restart = "on-failure";
      Service.RestartSec = 2;
      Service.ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    };
    security.pam.services.hyprlock = { };
    services.gnome.gnome-keyring.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    programs.dconf.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    environment.sessionVariables = {
      # SDDM/UWSM must receive the cursor theme before Hyprland starts.
      XCURSOR_THEME = config.home-manager.users.tongy.home.pointerCursor.name;
      XCURSOR_SIZE = toString config.home-manager.users.tongy.home.pointerCursor.size;
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    home-manager.users.tongy.home.sessionVariables = {
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
    home-manager.users.tongy.home.packages = with pkgs; [
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
    ];
    home-manager.users.tongy.gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font.name = "Atkinson Hyperlegible";
      font.size = 11;
      gtk4.extraConfig.gtk-theme-name = "adw-gtk3-dark";
    };
    home-manager.users.tongy.xdg.configFile = {
      "hypr/hyprland.lua".text =
        builtins.readFile ../assets/hypr/hyprland.lua
        + "\n"
        + config.tongy.monitorConfig
        + "\n"
        + config.tongy.extraHyprland;
      "hypr/lua".source = ../assets/hypr/lua;
    };
    home-manager.users.tongy.tongy.writableFiles.".config/caelestia/shell.json" =
      ../assets/caelestia/shell.json;
  };
}
