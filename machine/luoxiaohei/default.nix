{ lib
, config
, ...
}: {
  fileSystems."/" = {
    device = "/dev/vda1";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persistent" ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
}
