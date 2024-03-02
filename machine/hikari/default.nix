{ lib
, config
, ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" ];

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=2G" "mode=755" ];
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
              mountOptions = [ "dmask=077" "fmask=177" ];
            };
          };
          crypt-root = {
            priority = 100;
            size = "100%";
            content = {
              type = "luks";
              name = "crypt-root";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
              };
              content = {
                type = "btrfs";
                subvolumes = let
                  mountOptions = ["compress=zstd" "x-gvfs-hide" ];
                in {
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
                    swap.swapfile.size = "8G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
