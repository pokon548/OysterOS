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

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "sr_mod"
    "uhci_hcd"
    "virtio_pci"
    "virtio_blk"
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
