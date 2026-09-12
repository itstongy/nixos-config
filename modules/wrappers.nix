{ inputs, config, ... }@flake:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.ghostty = inputs.wrappers.wrappers.ghostty.wrap {
        inherit pkgs;
        settings = {
          background = "#2d353b";
          foreground = "#d3c6aa";
          background-opacity = 0.76;
          background-opacity-cells = true;
          background-blur = true;
          custom-shader = [ "${../assets/cursor_sweep.glsl}" ];
          cursor-color = "#d3c6aa";
          selection-background = "#d3c6aa";
          selection-foreground = "#2d353b";
          confirm-close-surface = false;
          font-family = "JetBrainsMono Nerd Font";
          font-size = 12;
          command = "${self'.packages.zsh}/bin/zsh";
          palette = [
            "0=#475258"
            "1=#e67e80"
            "2=#a7c080"
            "3=#dbbc7f"
            "4=#7fbbb3"
            "5=#d699b6"
            "6=#83c092"
            "7=#d3c6aa"
            "8=#475258"
            "9=#e67e80"
            "10=#a7c080"
            "11=#dbbc7f"
            "12=#7fbbb3"
            "13=#d699b6"
            "14=#83c092"
            "15=#d3c6aa"
          ];
        };
      };
      packages.zsh = inputs.wrappers.wrappers.zsh.wrap {
        inherit pkgs;
        runtimePkgs = with pkgs; [
          fzf
          fd
          eza
          zoxide
          direnv
          curl
          openssh
          yazi
        ];
        zshrc.content = ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ${../assets/p10k.zsh}
          ${builtins.readFile ../assets/zshrc}
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          eval "$(direnv hook zsh)"
        '';
      };
      packages.tmux = inputs.wrappers.wrappers.tmux.wrap {
        inherit pkgs;
        configAfter = builtins.replaceStrings [ "/usr/bin/zsh" ] [ "${self'.packages.zsh}/bin/zsh" ] (
          builtins.readFile ../assets/tmux.conf
        );
      };
      packages.git = inputs.wrappers.wrappers.git.wrap {
        inherit pkgs;
        settings = {
          user = {
            name = "Harrison Tong";
            email = "16379581+itstongy@users.noreply.github.com";
          };
          init.defaultBranch = "main";
          pull.rebase = true;
          fetch.prune = true;
          core.editor = "nvim";
          include.path = "~/.config/git/identity";
        };
      };
      packages.default = self'.packages.ghostty;
    };
  flake.modules.nixos.terminal =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      p = flake.config.flake.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      options.tongy.ghosttySoftwareRendering = lib.mkEnableOption "software rendering for Ghostty in a VM";
      config = {
        programs.zsh.enable = true;
        users.users.tongy.shell = p.zsh;
        environment.shells = [ p.zsh ];
        home-manager.users.tongy.home.packages = [
          (p.ghostty.wrap {
            settings = lib.optionalAttrs config.tongy.ghosttySoftwareRendering {
              custom-shader = lib.mkForce [ ];
            };
            env = lib.optionalAttrs config.tongy.ghosttySoftwareRendering { LIBGL_ALWAYS_SOFTWARE = "1"; };
          })
          p.zsh
          pkgs.yazi
          pkgs.eza
          pkgs.zoxide
          pkgs.openssh
          pkgs.ripgrep
          pkgs.fd
          pkgs.fzf
          pkgs.jq
          (lib.hiPrio p.tmux)
          (lib.hiPrio p.git)
        ];
      };
    };
}
