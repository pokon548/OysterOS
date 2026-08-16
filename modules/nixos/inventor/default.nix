# Invent the world!
#
# Just kidding. This is a customized desktop for OysterOS. Basically, it contains:
# 1. niri
# 2. noctalia
#
# ... with hand-crafted tweaks to be production-ready and vivid.
{
  config,
  pkgs,
  inputs',
  ...
}:
{
  imports = [
    inputs'.niri-nix.modules.default
    inputs'.noctalia.modules.default
  ];

  services = {
    xserver = {
      enable = true;
    };

    displayManager = {
      defaultSession = "niri";
      sessionPackages = with pkgs; [ niri ];
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "pokon548";
      };
    };
  };

  programs = {
    niri = {
      enable = true;
    };

    noctalia = {
      enable = true;

      systemd.enable = true;
      recommendedServices.enable = true;
    };
  };

  # GTK Scheme
  environment.variables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };

  programs.gpu-screen-recorder.enable = true;

  xdg.portal = {
    config = {
      common.default = [
        "hyprland"
        "gtk"
      ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
    ];
  };

  services.pipewire = {
    enable = true;
    package = pkgs.pipewire.overrideAttrs (old: {
      patches = old.patches ++ [
        #./patch/pipewire/higher-bitrate-for-sbc.patch
      ];
    });
    audio.enable = true;
    pulse.enable = true;
    /*
      alsa = {
        enable = true;
        support32Bit = true;
      };
    */
    wireplumber = {
      enable = true;
      extraConfig = {
        # Emulating 4.0 device seems breaking the sound frequently
        # Adding the following settings could workaround this problem
        # See https://forum.endeavouros.com/t/after-update-pipewire-needs-to-be-restarted-often/28111/21?page=2
        #
        # This also fix pop sound issue
        "20-workaround-sound-stuttering-sound" = {
          "monitor.alsa.rules" = [
            {
              "matches" = [
                {
                  "node.name" = "~alsa_output.*";
                }
              ];
              "actions" = {
                "update-props" = {
                  "api.alsa.headroom" = 1024;
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
    };
    extraConfig = {
      pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "16/48000";
              pulse.default.req = "512/48000";
              pulse.max.req = "512/48000";
              pulse.min.quantum = "16/48000";
              pulse.max.quantum = "512/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "512/48000";
          resample.quality = 10;
        };
      };
    };
  };

  services.psd = {
    enable = true;
    resyncTimer = "1m";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  services.gvfs.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  # GSConnect
  networking.firewall = {
    allowedTCPPortRanges = config.prefstore.network.port.kde-connect;
    allowedUDPPortRanges = config.prefstore.network.port.kde-connect;
  };

  # Workaround for fcitx5 issue under wayland. See: https://github.com/NixOS/nixpkgs/issues/129442
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
        (fcitx5-rime.override {
          rimeDataPkgs = [
            librime
            librime-lua
            rime-ice
          ];
        })
        libsForQt5.fcitx5-qt
      ];
      ignoreUserConfig = true;
      waylandFrontend = true;
      settings = {
        globalOptions = {
          Hotkey = {
            EnumerateSkipFirst = "False";
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
            "1" = "Shift_L";
          };
          Behavior = {
            ShareInputState = "Program";
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "默认";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };

          "Groups/0/Items/0" = {
            Name = "keyboard-us";
          };

          "Groups/0/Items/1" = {
            Name = "rime";
          };

          GroupOrder = {
            "0" = "默认";
          };
        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = "True";
            UseDarkTheme = "True";
            EnableFractionalScale = "True";
            Font = "Sarasa UI SC 12";
          };
          pinyin.globalSection = {
            EmojiEnabled = "True";
            CloudPinyinEnabled = "False";
            CloudPinyinIndex = 2;
            QuickPhraseKey = "";
            VAsQuickphrase = "False";
            ShuangpinProfile = "Xiaohe";
            FirstRun = "False";
          };
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gtk3
      adw-gtk3
      simp1e-cursors

      kitty
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";

      # Make steam usable
      STEAM_FORCE_DESKTOPUI_SCALING = "2";

      GOLDENDICT_FORCE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";

      LIBVA_DRIVER_NAME = "iHD";

      XDG_SESSION_TYPE = "wayland";

      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORM = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = 0;
      QT_ENABLE_HIGHDPI_SCALING = 1;
      QT_SCREEN_SCALE_FACTORS = "1;1.25";
      WEBKIT_DISABLE_DMABUF_RENDERER = 1;
    };
  };
}
