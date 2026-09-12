{ ... }: {
  perSystem = { pkgs, ... }: {
    packages.chatgpt =
      let
        files = pkgs.runCommand "chatgpt-26.901.51231-files" { nativeBuildInputs = [ pkgs.dpkg ]; } ''
          mkdir -p $out
          dpkg-deb -x ${
            pkgs.fetchurl {
              url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_26.901.51231_amd64.deb";
              sha256 = "0pn0qpmdsrk4mrdjv2nzshc2b8x888xwgdysd69klgbwv2402n32";
            }
          } $out
        '';
      in
      pkgs.buildFHSEnv {
        name = "chatgpt";
        targetPkgs =
          p: with p; [
            bash
            coreutils
            gtk3
            gtk4
            nss
            nspr
            alsa-lib
            cups
            dbus
            expat
            glib
            gdk-pixbuf
            cairo
            pango
            at-spi2-core
            libdrm
            mesa
            libgbm
            libglvnd
            libxkbcommon
            libx11
            libxcb
            libxcomposite
            libxdamage
            libxext
            libxfixes
            libxrandr
            libxshmfence
            libxtst
            libxi
            libxcursor
            libxrender
            openssl
            libsecret
            libnotify
            libusb1
            systemd
            zlib
            stdenv.cc.cc
            xdg-utils
            git
            openssh
          ];
        runScript = "${files}/usr/lib/chatgpt/codex-launcher";
        extraInstallCommands = ''
          mkdir -p $out/share/applications
          cp ${files}/usr/share/applications/chatgpt.desktop $out/share/applications/chatgpt.desktop
          cp -r ${files}/usr/share/pixmaps $out/share/
        '';
      };
    packages.helium =
      let
        pname = "helium-browser";
        version = "0.16.5.1";
        src = pkgs.fetchurl {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          sha256 = "37afb0c20e3ab9fb1b0aa109bff5a94d60c29c8ded9c5b79f1c1ba4ec1b15dec";
        };
        contents = pkgs.appimageTools.extract { inherit pname version src; };
      in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        extraInstallCommands = ''
          mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
          desktop=$(find ${contents} -maxdepth 2 -name '*.desktop' -print -quit)
          cp "$desktop" $out/share/applications/helium-browser.desktop
          substituteInPlace $out/share/applications/helium-browser.desktop --replace-fail 'Exec=helium' 'Exec=helium-browser'
          icon=$(find ${contents} -maxdepth 2 -name '*.png' -print -quit)
          if [ -n "$icon" ]; then cp "$icon" $out/share/icons/hicolor/256x256/apps/helium.png; fi
        '';
      };
  };
}
