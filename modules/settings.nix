{ inputs, ... }: {
  flake.modules.nixos.managed-settings = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupCommand = toString (
        pkgs.writeShellScript "backup-home-manager-file" ''
          exec ${pkgs.coreutils}/bin/mv --backup=numbered -T "$1" "$1.before-home-manager"
        ''
      );
      users.tongy =
        {
          config,
          lib,
          ...
        }:
        {
          options.tongy.writableFiles = lib.mkOption {
            type = lib.types.attrsOf lib.types.path;
            default = { };
            description = "Settings copied into the home directory on activation; application edits are temporary.";
          };
          config = {
            home.stateVersion = "26.05";
            systemd.user.startServices = "sd-switch";
            # The previous NixOS activation created direct store links which HM
            # deliberately refuses to back up. Hand over only those legacy paths.
            home.activation.migrateLegacyLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] (
              lib.concatMapStringsSep "\n"
                (
                  name:
                  let
                    target = "${config.home.homeDirectory}/.config/${name}";
                  in
                  ''
                    if [ -L ${lib.escapeShellArg target} ]; then
                      case "$(readlink ${lib.escapeShellArg target})" in
                        /nix/store/*-home-manager-files/*) ;;
                        /nix/store/*)
                          run ${pkgs.coreutils}/bin/mv --backup=numbered -T ${lib.escapeShellArg target} ${
                            lib.escapeShellArg (target + ".before-home-manager")
                          }
                          ;;
                      esac
                    fi
                  ''
                )
                [
                  "hypr/hyprland.lua"
                  "hypr/lua"
                  "gtk-3.0/settings.ini"
                  "gtk-4.0/settings.ini"
                  "vesktop/themes/everforest.css"
                  "vesktop/settings/quickCss.css"
                ]
            );
            home.activation.writableSettings =
              lib.hm.dag.entryBetween [ "reloadSystemd" ] [ "linkGeneration" ]
                (
                  lib.concatStringsSep "\n" (
                    lib.mapAttrsToList (
                      name: source:
                      let
                        target = "${config.home.homeDirectory}/${name}";
                      in
                      ''
                        run install -d -m 0755 ${lib.escapeShellArg (builtins.dirOf target)}
                        if [ -L ${lib.escapeShellArg target} ]; then
                          run rm -- ${lib.escapeShellArg target}
                        fi
                        run install -m 0644 ${lib.escapeShellArg (toString source)} ${lib.escapeShellArg target}
                      ''
                    ) config.tongy.writableFiles
                  )
                );
          };

        };
    };
  };
}
