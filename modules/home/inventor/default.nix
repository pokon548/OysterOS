{
  config,
  pkgs,
  inputs',
  modules',
  ...
}:
{
  imports = [
    modules'.homestore

    inputs'.niri-nix.modules.default
    inputs'.noctalia.modules.default
  ];

  services.kdeconnect.enable = true;

  wayland.windowManager.niri = {
    enable = true;
    settings = {
      prefer-no-csd = { };

      spawn-sh-at-startup = [
        {
          _args = [ "sleep 3 && noctalia msg volume-set 8" ];
        }
        {
          _args = [
            "sleep 10 && aw-qt --autostart-modules 'aw-server,aw-watcher-window-wayland,aw-watcher-afk'"
          ];
        }
        {
          _args = [
            "systemctl --user import-environment XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS WAYLAND_DISPLAY DISPLAY"
          ];
        }
        {
          _args = [ "kdeconnect-indicator" ];
        }
        {
          _args = [ "echo \"Xft.dpi: 200\" | xrdb -merge" ];
        }
        {
          _args = [ "echo \"Xcursor.size: 24\" | xrdb -merge" ];
        }
      ];

      cursor = {
        xcursor-theme = "Simp1e-Tokyo-Night-Light";
        xcursor-size = 24;
      };

      hotkey-overlay = {
        skip-at-startup = { };
      };

      animations = {
        workspace-switch.off = { };
        horizontal-view-movement.off = { };
        overview-open-close.off = { };
      };

      window-rule = [
        {
          match = {
            _props.app-id._raw = ''r#"^io\.github\.diegoivanme\.flowtime$"#'';
          };

          open-floating = true;
        }
        {
          match = {
            _props.app-id._raw = ''r#"^org\.gnome\.Solanum$"#'';
          };

          open-floating = true;
        }
      ];

      # TODO: Make open-on-output respect config
      workspace = [
        {
          _args = [ "" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "󰑴" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "" ];
          open-on-output = "eDP-1";
        }
        {
          _args = [ "" ];
          open-on-output = "HDMI-A-1";
        }
        {
          _args = [ "" ];
          open-on-output = "HDMI-A-1";
        }
        {
          _args = [ "" ];
          open-on-output = "HDMI-A-1";
        }
        {
          _args = [ "" ];
          open-on-output = "HDMI-A-1";
        }
      ];

      binds = {
        "Mod+T" = {
          spawn = "kitty";
        };
        "Mod+B" = {
          spawn = "zen-browser";
        };
        "Mod+Space" = {
          spawn-sh = "noctalia msg panel-toggle launcher";
        };
        "Mod+Shift+S" = {
          spawn-sh = "pkill -SIGINT -f gpu-screen-recorder && notify-send 回放已保存！";
        };
        "Mod+N" = {
          spawn-sh = "swaync-client -t -sw";
        };

        "Alt+Z" = {
          focus-workspace = "";
        };
        "Alt+X" = {
          focus-workspace = "󰑴";
        };
        "Alt+C" = {
          focus-workspace = "";
        };
        "Alt+A" = {
          focus-workspace = "";
        };
        "Alt+S" = {
          focus-workspace = "";
        };
        "Alt+D" = {
          focus-workspace = "";
        };
        "Alt+Q" = {
          focus-workspace = "";
        };
        "Alt+W" = {
          focus-workspace = "";
        };
        "Alt+E" = {
          focus-workspace = "";
        };
        "Alt+R" = {
          focus-workspace = "";
        };
        "Alt+Mod+Z" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+X" = {
          move-column-to-workspace = "󰑴";
        };
        "Alt+Mod+C" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+A" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+S" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+D" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+Q" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+W" = {
          move-column-to-workspace = "";
        };
        "Alt+Mod+R" = {
          move-column-to-workspace = "";
        };

        "Mod+Shift+R" = {
          switch-preset-window-height = { };
        };

        "Mod+Z" = {
          spawn-sh = "noctalia msg notification-dnd-toggle";
        };
        "Mod+V" = {
          spawn-sh = "noctalia msg panel-toggle clipboard";
        };
        "Alt+Mod+L" = {
          spawn-sh = "noctalia ipc call lockScreen toggle";
        };
        "Alt+Mod+V" = {
          toggle-window-floating = { };
        };
      };
    }
    // config.homestore.niri.outputConfig;
  };

  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        ui_scale = 1.15;
        font_family = "更纱黑体 UI SC";
        setup_wizard_enabled = false;
        animation.enabled = false;
        panel.transparency_mode = "glass";
        borders = false;
        shadow = false;
      };

      bar.main = {
        background_opacity = 0.65;
        border_width = 0;
        shadow = false;
        radius = 0;
        margin_ends = 0;
        margin_edge = 0;
        scale = 1.15;
        widget_spacing = 8;

        start = [ "workspaces" ];
        center = [
          "notes"
          "clock"
          "notifications"
        ];
        end = [
          "media"
          "tray"
          "network"
          "bluetooth"
          "volume"
          "battery"
          "control-center"
          "session"
        ];
      };

      theme = {
        mode = "auto";
        source = "builtin";
        builtin = "Tokyo-Night";
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "niri"
            "helix"
            "gtk4"
            "kcolorscheme"
            "qt"
            "kitty"
          ];
        };
      };

      location = {
        auto_locate = true;
      };

      nightlight = {
        enabled = true;
        temperature_day = 6500; # Kelvin (must be > temperature_night by at least 100)
        temperature_night = 2500; # Kelvin
      };

      brightness = {
        enable_ddcutil = true;
      };

      hooks = {
        started = ''if [[ "$NOCTALIA_THEME_MODE" == "dark" ]]; then ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme '"adw-gtk3-dark"'; else ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme '"adw-gtk3"'; fi'';
        theme_mode_changed = ''if [[ "$NOCTALIA_THEME_MODE" == "dark" ]]; then ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme '"adw-gtk3-dark"'; else ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme '"adw-gtk3"'; fi'';
      };

      wallpaper = {
        enabled = true;
        directory = "~/Pictures/Wallpapers";
      };

      widget = {
        clock = {
          format = "%x %A %p%l:%M:%S";
        };
        network.show_label = false;
        workspaces = {
          display = "name";
        };
        tray = {
          drawer = true;
          pinned = [
            "Fcitx*"
            "Todoist"
          ];
        };
        volume.show_label = false;
      };

      plugins = {
        enabled = [
          "noctalia/screen_recorder"
          "noctalia/world_clock"
          "noctalia/notes"
        ];
        auto_update = true;

        source = [
          {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            enabled = true;
          }
        ];
      };
    };
  };

  home = {
    packages = with pkgs; [
      kitty
      gnome-clocks
      baobab
      nautilus
      file-roller
      gnome-text-editor
      gnome-calculator
      loupe
      xwayland-satellite
      mpv
      fastfetch
      pavucontrol

      (writeShellScriptBin "hibernate-with-monitors" ''
        sudo ${ddcutil}/bin/ddcutil setvcp D6 05
        sudo ${systemd}/bin/systemctl suspend
      '')

      (writeShellScriptBin "close-all-monitors" ''
        sudo ${ddcutil}/bin/ddcutil setvcp D6 05
        ${wlr-randr}/bin/wlr-randr --output eDP-1 --off
        sudo ${auto-cpufreq}/bin/auto-cpufreq --force=powersave
        sudo ${auto-cpufreq}/bin/auto-cpufreq --turbo=never
        echo 100000 | sudo ${coreutils-full}/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
      '')

      (writeShellScriptBin "open-all-monitors" ''
        echo 4500000 | sudo ${coreutils-full}/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
        sudo ${auto-cpufreq}/bin/auto-cpufreq --force=performance
        sudo ${auto-cpufreq}/bin/auto-cpufreq --turbo=auto
        sudo ${ddcutil}/bin/ddcutil setvcp D6 01
        ${wlr-randr}/bin/wlr-randr --output eDP-1 --on
      '')
    ];

    global-persistence.directories = [
      ".config/kitty"
    ];
  };
}
