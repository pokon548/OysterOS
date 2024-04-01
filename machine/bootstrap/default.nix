{ lib
, config
, modulesPath
, ...
}: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  disko.devices = {
    disk.main = {
      imageSize = "2G";
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
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "nosuid" "nodev" ];
            };
          };
        };
      };
    };
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
    "vmw_pvscsi"

    "virtio_net"
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_scsi"
  ];

  boot.initrd.kernelModules = [
    "nvme"

    "virtio_balloon"
    "virtio_console"
    "virtio_rng"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
}
