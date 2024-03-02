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
  system.stateVersion = "23.11";

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
  };
}
