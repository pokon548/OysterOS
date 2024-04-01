{ lib
, config
, ...
}: {
  disko.devices = {
    disk.main = {
      imageSize = "4G";
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
            priority = 0;
          };

          ESP = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            priority = 1;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "fmask=0077" "dmask=0077" ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              mountOptions = [ "compress-force=zstd" "nosuid" "nodev" ];
            };
          };
        };
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
}
