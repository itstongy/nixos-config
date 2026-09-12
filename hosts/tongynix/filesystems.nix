# Fresh-install layout. Create these labels on the chosen SYSTEM disk.
# These are installation targets, not the current Arch partition labels.
{ ... }: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/tongynix-root";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/TONGYBOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
