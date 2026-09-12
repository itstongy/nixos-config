{ ... }: {
  flake.modules.nixos.screenshots =
    { pkgs, lib, ... }:
    let
      dependencies = with pkgs; {
        hypr-open-or-focus = [
          hyprland
          jq
        ];
        hypr-copy-paste = [
          hyprland
          gnused
          coreutils
        ];
        take-screenshot = [
          coreutils
          grim
          slurp
          wl-clipboard
          libnotify
        ];
        ocr-screenshot = [
          coreutils
          grim
          slurp
          tesseract
          wl-clipboard
          libnotify
        ];
      };
    in
    {
      home-manager.users.tongy.home.packages = lib.mapAttrsToList (
        name: runtimeInputs:
        pkgs.writeShellApplication {
          inherit name runtimeInputs;
          text = builtins.readFile (../assets/scripts + "/${name}");
        }
      ) dependencies;
    };
}
