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
      device = "/dev/vda";
      type = "disk";
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
    "xhci_pci"
    "ahci"
    "virtio_pci"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [
    "virtio_gpu"
  ];

  boot.kernelParams = [
    "tcp_bbr"
    "console=tty"
  ];

  networking = {
    interfaces = {
      enp1s0.ipv6.addresses = [{
        address = "2a01:4f9:c010:a9ed::add:6";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
}
