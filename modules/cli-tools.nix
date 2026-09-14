{ ... }: {
  perSystem = { pkgs, ... }: {
    # Nixpkgs uses autoreconf for cmatrix, which enables use_default_colors.
    # The Arch CMake build omits it. No runtime wrapper is needed.
    packages.cmatrix = pkgs.cmatrix;
    packages.cli-tools = pkgs.buildEnv {
      name = "tongy-cli-tools";
      paths = with pkgs; [
        cmatrix
        fast
        speedtest-cli
        gh
        fastfetch
        fetch
        tldr
        glances
      ];
    };
  };
}
