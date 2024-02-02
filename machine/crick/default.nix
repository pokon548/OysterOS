{ lib
, config
, ...
}: {
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=25%" "mode=755" ];
  };

  fileSystems."${config.prefstore.system.impermanence.location}" = {
    device = "/dev/root_vg/persistent";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persistent" ];
  };

  fileSystems."/nix" = {
    device = "/dev/root_vg/nix";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
