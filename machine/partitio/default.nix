{ lib
, config
, inputs
, pkgs
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
                      swap.swapfile.size = "48G";
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
  boot.kernelParams = [ "resume_offset=83404032" ];
  #boot.kernelModules = [ "i915.force_probe=7d55" ];

  services.hardware.bolt.enable = true;
  services.thermald.enable = true;
  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Workaround: https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/766
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=generic
    options snd-hda-intel dmic_detect=0
    blacklist snd_soc_skl
  '';

  # Workaround: Lenovo seems f**ked up acpi power management. Without this config,
  #             suspend (to ram / disk) will simply reboot instead of power off. :(
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
  '';

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva
      intel-ocl
      intel-vaapi-driver
    ];
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
