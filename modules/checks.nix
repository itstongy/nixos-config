{ ... }: {
  perSystem = { pkgs, ... }: {
    checks.caelestia-config =
      pkgs.runCommand "caelestia-config-check"
        {
          nativeBuildInputs = [ pkgs.quickshell ];
          QT_QPA_PLATFORM = "offscreen";
          QML_IMPORT_PATH = "${pkgs.caelestia-shell.plugin}/lib/qt-6/qml";
        }
        ''
          export HOME="$TMPDIR/home"
          export XDG_CONFIG_HOME="$HOME/.config"
          export XDG_CACHE_HOME="$HOME/.cache"
          export XDG_RUNTIME_DIR="$TMPDIR/runtime"
          mkdir -p "$XDG_CONFIG_HOME/caelestia" "$XDG_CACHE_HOME" "$XDG_RUNTIME_DIR"
          chmod 700 "$XDG_RUNTIME_DIR"
          cp ${../assets/caelestia/shell.json} "$XDG_CONFIG_HOME/caelestia/shell.json"
          timeout 15 quickshell --path ${../tests/caelestia-config.qml} --no-color > check.log 2>&1
          cat check.log
          grep -q CONFIG_CHECK_PASSED check.log
          if grep -q CONFIG_CHECK_FAILED check.log; then exit 1; fi
          touch "$out"
        '';
  };
}
