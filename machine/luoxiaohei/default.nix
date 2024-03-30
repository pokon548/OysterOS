{ lib
, config
, ...
}: {
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "btrfs";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
}
