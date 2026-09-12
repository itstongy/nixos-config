{ inputs, ... }: {
  flake.modules.nixos.dictation =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.tongy.dictation;
      model = pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-large-v3-turbo.bin";
        hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
      };
      settings = pkgs.writeText "voxtype.toml" (
        builtins.replaceStrings [ "model = \"large-v3-turbo\"" ] [ "model = \"${model}\"" ] (
          builtins.readFile ../assets/voxtype.toml
        )
      );
      voice = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.voxtype.override { vulkanSupport = cfg.vulkan; };
        flags."--config" = "${settings}";
      };
    in
    {
      options.tongy.dictation.enable = lib.mkEnableOption "VoxType dictation";
      options.tongy.dictation.vulkan = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Build Voxtype with Vulkan acceleration for a physical GPU.";
      };
      config = lib.mkIf cfg.enable {
        tongy.extraHyprland = lib.mkAfter ''hl.bind("SUPER + CTRL + X", hl.dsp.exec_cmd("voxtype record toggle"), { description = "Voice dictation" })'';
        home-manager.users.tongy.home.packages = [ (lib.hiPrio voice) ];
        home-manager.users.tongy.systemd.user.services.voxtype = {
          Unit.Description = "Push-to-talk dictation";
          Install.WantedBy = [ "graphical-session.target" ];
          Unit.PartOf = [ "graphical-session.target" ];
          Unit.After = [
            "graphical-session.target"
            "pipewire.service"
            "pipewire-pulse.service"
          ];
          # The same desktop profile starts dictation automatically on bare metal.
          Unit.ConditionVirtualization = "!vm";
          Service = {
            Environment = "PATH=/etc/profiles/per-user/tongy/bin:/run/current-system/sw/bin:/run/wrappers/bin";
            ExecStart = "${voice}/bin/voxtype -q daemon";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      };
    };
}
