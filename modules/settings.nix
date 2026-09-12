{ ... }: {
  flake.modules.nixos.managed-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.tongy.settings = lib.mkOption {
        default = { };
        description = "Dotfiles owned by this configuration, relative to the user's home.";
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              source = lib.mkOption { type = lib.types.path; };
              writable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Install a writable copy on every activation for applications which save settings.";
              };
            };
          }
        );
      };
      config.system.activationScripts.desktop-settings = {
        deps = [ "users" ];
        text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: entry:
            let
              target = "${config.users.users.tongy.home}/${name}";
            in
            ''
              ${pkgs.coreutils}/bin/install -d -m 0755 -o tongy -g users ${lib.escapeShellArg (builtins.dirOf target)}
            ''
            + (
              if entry.writable then
                ''
                  if [ -L ${lib.escapeShellArg target} ]; then rm -- ${lib.escapeShellArg target}; fi
                  ${pkgs.coreutils}/bin/install -m 0644 -o tongy -g users ${lib.escapeShellArg (toString entry.source)} ${lib.escapeShellArg target}
                ''
              else
                ''
                  if [ -e ${lib.escapeShellArg target} ] && [ ! -L ${lib.escapeShellArg target} ]; then
                    mv -- ${lib.escapeShellArg target} ${
                      lib.escapeShellArg (target + ".before-nixos")
                    }.$(${pkgs.coreutils}/bin/date +%s)
                  fi
                  ln -sfnT ${lib.escapeShellArg (toString entry.source)} ${lib.escapeShellArg target}
                  chown -h tongy:users ${lib.escapeShellArg target}
                ''
            )
          ) config.tongy.settings
        );
      };
    };
}
