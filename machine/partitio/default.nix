{ lib
, config
, inputs
, ...
}:
{
  imports = with inputs.hardware.nixosModules;
    [
      common-pc-ssd
      common-cpu-intel
    ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
    "tpm"
    "tpm_tis"
    "tpm_crb"
  ];

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=4G" "mode=755" ];
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
                subvolumes =
                  let
                    mountOptions = [ "compress=zstd" "x-gvfs-hide" ];
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
                      swap.swapfile.size = "24G";
                    };
                  };
              };
            };
          };
        };
      };
    };
  };

  # NOTE: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
  boot.resumeDevice = "/dev/disk/by-uuid/c3a162bc-60ed-474e-b0ba-7456eba0483d";
  boot.kernelParams = [ "resume_offset=52591513" ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  system.stateVersion = "23.11";
}
