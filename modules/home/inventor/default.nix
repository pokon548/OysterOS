{
  pkgs,
  inputs',
  ...
}:
{
  imports = [
    inputs'.noctalia.modules.default
  ];

  services.kdeconnect.enable = true;

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
      ".config/niri"
      ".config/kitty"
    ];
  };
}
