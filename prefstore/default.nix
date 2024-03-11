{ pkgs
, inputs
, config
, lib
, ...
}:
with lib;
let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit pkgs lib;
  };
  nixpakModules = {
    gui-base = inputs.nixpak-pkgs + "/pkgs/modules/gui-base.nix";
  };

  appPersistOpts = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The name of the user account. If undefined, the name of the
          attribute set will be used.
        '';
      };

      directories = mkOption {
        type = types.listOf (types.anything);
        default = [ ];
      };

      files = mkOption {
        type = types.listOf (types.anything);
        default = [ ];
      };
    };
  };

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

      programs = mkOption {
        type = types.attrs;
        default = { };
      };

      file = mkOption {
        type = types.attrs;
        default = { };
      };

      application = {
        base = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        gnome-extra = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        office = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        internet = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        security = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        knowledge = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        development = mkOption {
          type = types.listOf (types.package);
          default = [ ];
        };

        game = mkOption {
          type = types.listOf (types.package);
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

      boot = {
        latestKernel = mkOption {
          type = types.bool;
          default = false;
        };
        secureboot = mkOption {
          type = types.bool;
          default = false;
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
          application = genAttrs
            (
              lists.remove null (
                forEach
                  (mapAttrsToList
                    (
                      name: value: { name = name; type = value; }
                    )
                    (builtins.readDir ../desktop/application))
                  (x: if x.type == "directory" then toString x.name else null))
            )
            (name: mkOption {
              type = types.package;
              default = (inputs.haumea.lib.load
                {
                  src = ../desktop/application + ("/" + name);
                  inputs = {
                    inherit lib config pkgs mkNixPak nixpakModules;
                  };
                }).default.config.env;
            });
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

          network = {
            useNetworkManager = mkOption {
              type = types.bool;
              default = true;
            };
            port = {
              ssh = mkOption {
                type = types.int;
                default = 64548;
              };
            };
          };

          virtualisation = {
            virtualbox = mkOption {
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

            hideMounts = mkOption {
              type = types.bool;
              default = true;
            };

            directories = mkOption {
              type = types.listOf (types.anything);
              default = [
                "/var/lib/bluetooth"
                "/var/lib/nixos"
                "/var/lib/systemd/coredump"
                "/etc/NetworkManager/system-connections"

                { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
              ];
            };

            files = mkOption {
              type = types.listOf (types.anything);
              default = [
                "/etc/machine-id"
                { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
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
          openssh = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };
          };
        };

      appPersist = genAttrs
        (
          lists.remove null (
            forEach
              (mapAttrsToList
                (
                  name: value: { name = name; type = value; }
                )
                (builtins.readDir ../desktop/application))
              (x: if x.type == "directory" then toString x.name else null))
        )
        (name: mkOption {
          type = with types; attrsOf (submodule appPersistOpts);
          default = (inputs.haumea.lib.load
            {
              src = ../desktop/application + ("/" + name);
              inputs = {
                inherit lib config pkgs mkNixPak nixpakModules;
              };
            }).persist;
        });

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
