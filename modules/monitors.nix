{ ... }: {
  flake.modules.nixos.compositor = { lib, ... }: {
    options.tongy.extraHyprland = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
    options.tongy.monitorConfig = lib.mkOption {
      type = lib.types.lines;
      default = ''hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })'';
      description = "Host-specific Hyprland monitor declarations.";
    };
  };
}
