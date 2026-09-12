{ ... }: {
  perSystem = { pkgs, self', ... }: {
    checks.portable =
      pkgs.runCommand "portable-config-check" { nativeBuildInputs = [ self'.packages.cli ]; }
        ''
          ${builtins.readFile ../tests/portable.sh}
          touch "$out"
        '';
    packages.cli = pkgs.buildEnv {
      name = "tongy-cli";
      paths =
        with self'.packages;
        [
          zsh
          tmux
          git
          neovim
          btop
        ]
        ++ (with pkgs; [
          yazi
          eza
          zoxide
          openssh
          direnv
          nix-direnv
          ripgrep
          fd
          fzf
          jq
          curl
          less
          unzip
          zip
        ]);
    };
    packages.shell = pkgs.writeShellScriptBin "tongy-shell" ''
      export PATH="${self'.packages.cli}/bin:$PATH"
      export SHELL="${self'.packages.zsh}/bin/zsh"
      exec "$SHELL" "$@"
    '';
    devShells.default = pkgs.mkShell { packages = [ self'.packages.cli ]; };
    devShells.nix = pkgs.mkShell {
      packages = [
        self'.packages.cli
        pkgs.nixfmt
        pkgs.nixd
        pkgs.statix
        pkgs.deadnix
      ];
    };
    devShells.python = pkgs.mkShell {
      packages = [
        self'.packages.cli
        pkgs.python3
        pkgs.uv
      ];
    };
    devShells.node = pkgs.mkShell {
      packages = [
        self'.packages.cli
        pkgs.nodejs
      ];
    };
    devShells.rust = pkgs.mkShell {
      packages = [
        self'.packages.cli
        pkgs.rustc
        pkgs.cargo
        pkgs.rustfmt
        pkgs.clippy
        pkgs.rust-analyzer
        pkgs.pkg-config
      ];
    };
  };
}
