{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=4G"
        "mode=755"
      ];
    };
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 0;
            size = "700M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "dmask=077"
                "fmask=177"
              ];
            };
          };
          crypt-root = {
            priority = 100;
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes =
                let
                  mountOptions = [
                    "compress=zstd:1"
                    "nodiscard"
                    "x-gvfs-hide"
                    "space_cache=v2"
                    "x-systemd.after=local-fs-pre.target"
                  ];
                in
                {
                  "@persist" = {
                    mountpoint = "/persist";
                    inherit mountOptions;
                  };
                  "@var-log" = {
                    mountpoint = "/var/log";
                    inherit mountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    inherit mountOptions;
                  };
                  "@swap" = {
                    mountpoint = "/swap";
                    inherit mountOptions;
                    #swap.swapfile.size = "4G"; # I don't know how to automatically create swap file. So leave it as-is
                  };
                };
            };
          };
        };
      };
    };
  };
}
