{ pkgs
, inputs
, config
, lib
, ...
}:
with lib;
let
  homeOpts = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.passwdEntry types.str;
        apply = x: assert (builtins.stringLength x < 32 || abort "Username '${x}' is longer than 31 characters which is not allowed!"); x;
        description = lib.mdDoc ''
          The name of the user account. If undefined, the name of the
          attribute set will be used.
        '';
      };

      noReleaseCheck = mkOption {
        type = types.bool;
        default = false;
      };

      persistence = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };

        directories = mkOption {
          type = types.listOf (types.anything);
          default = [ ];
        };

        files = mkOption {
          type = types.listOf (types.anything);
          default = [ ];
        };

        allowOthers = mkOption {
          type = types.bool;
          default = false;
        };
      };

      application = {
        base = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        gnome-extra = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        office = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        internet = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        security = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        knowledge = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        development = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };

        game = mkOption {
          type = with types; listOf (attrsOf anything);
          default = [ ];
        };
      };

      gnome = {
        extension = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };
        dconf = mkOption {
          type = types.attrs;
          default = { };
        };
      };
    };

    config = mkMerge
      [{
        name = mkDefault name;
      }];
  };
in
{
  options.prefstore =
    {
      slogan = mkOption {
        type = types.str;
        default = ''
          Welcome to OysterOS!

          Run 'nixos-helo' for the NixOS manual

        '';
      };

      timeZone = mkOption {
        type = types.str;
        default = "Etc/UTC";
      };

      boot = {
        latestKernel = mkOption {
          type = types.bool;
          default = false;
        };
        secureboot = mkOption {
          type = types.bool;
          default = false;
        };
        grub = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          device = mkOption {
            type = types.path;
          };
        };
        systemd = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };
        };
      };

      desktop =
        {
          gnome = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };
          };

          im = mkOption {
            type = types.bool;
            default = false;
          };

          font = mkOption {
            type = types.bool;
            default = false;
          };

          xdg = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };

            defaultApplications = mkOption {
              type = with types; attrsOf (
                coercedTo (either (listOf str) str) (x: concatStringsSep ";" (toList x)) str
              );
              default = { };
            };
          };
        };

      system =
        {
          sudo.noPassword = mkOption {
            type = types.bool;
            default = true;
          };

          sysrq = mkOption {
            type = types.bool;
            default = false;
          };

          tpm = mkOption {
            type = types.bool;
            default = false;
          };

          network = {
            useNetworkManager = mkOption {
              type = types.bool;
              default = true;
            };
            domain = {
              headscale = mkOption {
                type = types.str;
                default = "derper-private.pokon548.ink";
              };
              vaultwarden = mkOption {
                type = types.str;
                default = "bitwarden.pokon548.ink";
              };
            };
            port = {
              https = mkOption {
                type = types.int;
                default = 443;
              };

              ssh = mkOption {
                type = types.int;
                default = 64548;
              };

              headscale = mkOption {
                type = types.int;
                default = 58251;
              };

              transmission = mkOption {
                type = types.listOf (types.attrsOf types.port);
                default = [
                  { from = 51413; to = 51413; }
                ];
              };

              vaultwarden = mkOption {
                type = types.int;
                default = 27313;
              };

              kde-connect = mkOption
                {
                  type = types.listOf (types.attrsOf types.port);
                  default = [
                    { from = 1714; to = 1764; }
                  ];
                };
            };
          };

          virtualisation = {
            virtualbox = mkOption {
              type = types.bool;
              default = false;
            };

            libvirtd = mkOption {
              type = types.bool;
              default = false;
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
              type = types.listOf (types.str);
              default = [
                "/var/lib/bluetooth"
                "/var/lib/nixos"
                "/var/lib/systemd/coredump"
                "/etc/NetworkManager/system-connections"
              ];
            };

            files = mkOption {
              type = types.listOf (types.str);
              default = [
                "/etc/machine-id"
              ];
            };
          };

          i18n = mkOption {
            type = types.bool;
            default = false;
          };
        };

      service =
        {
          caddy = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };
          };

          openssh = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };
          };

          headscale = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };

            private_key_path = mkOption {
              type = types.path;
            };

            noise.private_key_path = mkOption {
              type = types.path;
            };
          };

          rustdesk-server = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };
          };

          postgresql = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };
          };

          vaultwarden = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };

            environmentFile = mkOption {
              type = with types; nullOr path;
              default = null;
            };
          };
        };

      home = mkOption {
        default = { };
        type = with types; attrsOf (submodule homeOpts);
      };

      user = {
        root = mkOption {
          type = types.bool;
          default = true;
        };

        ritsu = mkOption {
          type = types.bool;
          default = false;
        };

        bootstrapper = mkOption {
          type = types.bool;
          default = false;
        };

        nixostest.enable = mkOption {
          type = types.bool;
          default = false;
        };

        pokon548 = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };
        };
      };
    };
}
