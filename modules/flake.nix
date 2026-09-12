{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
  systems = [ "x86_64-linux" ];
  perSystem = { pkgs, ... }: { formatter = pkgs.nixfmt; };
  flake.nixosModules = config.flake.modules.nixos;
  flake.nixosConfigurations = lib.mapAttrs (
    name: _:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        config.flake.modules.nixos.desktop
        (../hosts + "/${name}")
      ];
    }
  ) (lib.filterAttrs (_: kind: kind == "directory") (builtins.readDir ../hosts));
  flake.modules.nixos.desktop = {
    imports = with config.flake.modules.nixos; [
      base
      terminal
      editor
      applications
      compositor
      integration
      screenshots
      launcher
      appearance
      managed-settings
      activity
      dictation
    ];
  };
}
