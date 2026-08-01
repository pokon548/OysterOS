# Custom module to define dconf like build-time config for OysterOS!
{
  lib,
  ...
}:
{
  options.prefstore = with lib; {
    slogan = mkOption {
      type = types.str;
      default = ''
        Welcome to OysterOS!

        Run 'nixos-hello' for the NixOS manual

      '';
    };

    runningInVM = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether OysterOS is running as a VM.
        When this flag is set to true, some config are adjusted to suit the need of VM.
      '';
    };

    boot = {
      kernel = mkOption {
        type = types.enum [
          "lts"
          "latest"
          "zen"
        ];
        default = "lts";
        description = ''
          Which kernel will be using.
        '';
      };

      loader = mkOption {
        type = types.enum [
          "grub"
          "systemd"
        ];
        default = "grub";
        description = ''
          Which loader will be using.
        '';
      };

      secureboot = mkOption {
        type = types.bool;
        default = false;
      };
    };

    nix = {
      useChinaMirror = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether add China mirror into nix binary cache.
        '';
      };
    };
  };
}
