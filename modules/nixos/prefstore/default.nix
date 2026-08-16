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

    enableChinaFeatures = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether enable China specific features.
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

    region = {
      timeZone = lib.mkOption {
        default = "Etc/UTC";
        type = lib.types.str;
        example = "America/New_York";
        description = ''
          The time zone used when displaying times and dates. See <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>
          for a comprehensive list of possible values for this setting.

          If null, the timezone will default to UTC and can be set imperatively
          using timedatectl.
        '';
      };

      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        example = "nl_NL.UTF-8";
        description = ''
          The default locale. It determines the language for program messages,
          the format for dates and times, sort order, and so on. Setting the
          default character set is done via {option}`i18n.defaultCharset`.
        '';
      };
    };

    impermanence = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      location = mkOption {
        type = types.str;
        default = "/persist";
      };

      directories = mkOption {
        type = with types; listOf anything;
        default = [
          "/var/lib/bluetooth"
          "/var/lib/colord"
          "/var/lib/nixos"
          "/var/lib/NetworkManager"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
        ];
      };

      files = mkOption {
        type = with types; listOf anything;
        default = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
            how = "symlink";
            configureParent = true;
          }
        ];
      };
    };

    network = {
      port = {
        kde-connect = mkOption {
          type = types.listOf (types.attrsOf types.port);
          default = [
            {
              from = 1714;
              to = 1764;
            }
          ];
        };
      };
    };
  };
}
