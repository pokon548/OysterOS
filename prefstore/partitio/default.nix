{ pkgs
, config
, lib
, application
, ...
}:
with lib;
{
  config = {
    sops.secrets = {
      "tailscale/auth-key" = { };
    };

    prefstore = {
      # TODO: partitio prefstore is currently broken. Needed to be fixed soon ™
      slogan = ''
        I'll be back once I eliminate that devil called poverty from the world!

        Run 'nixos-helo' for the NixOS manual

      '';

      timeZone = "Asia/Shanghai";

      boot = {
        secureboot = true;
        systemd = {
          enable = true;
        };
        latestKernel = true;
      };

      desktop = {
        font = true;
        im = true;
        ozone = false;
        gnome = {
          enable = true;
        };
        xdg = {
          enable = true;
          defaultApplications = {
            # Image
            "image/jpeg" = "org.gnome.Loupe.desktop";
            "image/png" = "org.gnome.Loupe.desktop";
            "image/gif" = "org.gnome.Loupe.desktop";
            "image/webp" = "org.gnome.Loupe.desktop";
            "image/tiff" = "org.gnome.Loupe.desktop";
            "image/x-tga" = "org.gnome.Loupe.desktop";
            "image/vnd-ms.dds" = "org.gnome.Loupe.desktop";
            "image/x-dds" = "org.gnome.Loupe.desktop";
            "image/bmp" = "org.gnome.Loupe.desktop";
            "image/vnd.microsoft.icon" = "org.gnome.Loupe.desktop";
            "image/vnd.radiance" = "org.gnome.Loupe.desktop";
            "image/x-exr" = "org.gnome.Loupe.desktop";
            "image/x-portable-bitmap" = "org.gnome.Loupe.desktop";
            "image/x-portable-graymap" = "org.gnome.Loupe.desktop";
            "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";
            "image/x-portable-anymap" = "org.gnome.Loupe.desktop";
            "image/x-qoi" = "org.gnome.Loupe.desktop";
            "image/svg+xml" = "org.gnome.Loupe.desktop";
            "image/svg+xml-compressed" = "org.gnome.Loupe.desktop";
            "image/avif" = "org.gnome.Loupe.desktop";
            "image/heic" = "org.gnome.Loupe.desktop";
            "image/jxl" = "org.gnome.Loupe.desktop";

            # Browser
            "x-scheme-handler/http" = "librewolf.desktop";
            "text/html" = "librewolf.desktop";
            "application/xhtml+xml" = "librewolf.desktop";
            "x-scheme-handler/https" = "librewolf.desktop";

            # Email
            "x-scheme-handler/mailto" = "thunderbird.desktop";

            # Text
            "text/plain" = "org.gnome.TextEditor.desktop";

            # PDF
            "application/pdf" = "org.gnome.Papers.desktop";

            # Compression
            "application/zip" = "org.gnome.FileRoller.desktop";
          };
        };
      };

      system = {
        impermanence.enable = true;
        i18n = true;
        sudo.noPassword = true;
        sysrq = true;
        tpm = true;
        virtualisation = {
          virtualbox = true;
          libvirtd = true;
        };
      };

      service = {
        tailscale = {
          enable = true;
          authKeyFile = config.sops.secrets."tailscale/auth-key".path;
        };

        safeeyes.enable = true;
      };

      home.pokon548 = {
        noReleaseCheck = true;
        persistence = {
          enable = true;
          directories = [
            "公共"
            "视频"
            "图片"
            "文档"
            "下载"
            "音乐"
            "桌面"
            "Programmings"

            ".config/gsconnect"
            ".config/cronomix"
          ];
          files = [
            ".config/monitors.xml"
          ];
        };
        application = {
          base = with application; [
            vim
            helix
            sudo
            bat
            git
            gtk
            p7zip
            jq

            fish
          ];

          gnome-extra = with application; [
            amberol
            abiword
            authenticator
            bottles
            blanket
            celluloid
            eyedropper
            gnome-tweaks
            mission-center
            drawing
            metadata-cleaner
            gnome-solanum
            gnome-frog
            newsflash
            easyeffects
            remmina
            kooha
            vaults
            flowtime
            sticky
            rnote
          ];

          office = with application; [
            libreoffice-fresh
            wpsoffice

            safeeyes
          ];

          security = with application; [
            bitwarden-desktop
            keepassxc
            seahorse
          ];

          internet = with application; [
            thunderbird
            todoist-electron
            librewolf
            ungoogled-chromium
            localsend
            element-desktop
            rustdesk
            zhixi
            transmission
            qq
            wechat
            samba
          ];

          knowledge = with application; [
            anki
            koreader
            chengla-electron
            geogebra
            obsidian
            goldendict-ng
            zotero
          ];

          development = with application; [
            android-studio-canary
            android-tools
            vscodium
            virtualbox
            virt-manager
          ];

          game = with application; [
            steam
            prismlauncher
            minigames
          ];
        };
        gnome = {
          # TODO: Remove workaround after https://github.com/NixOS/nixpkgs/pull/304245 merged into unstable
          extension = with pkgs; with pkgs.gnomeExtensions; [
            gsconnect
            gnome46Extensions."appindicatorsupport@rgcjonas.gmail.com"
            dash-to-dock
            kimpanel

            clipboard-history
            emoji-copy
            just-perfection
            pip-on-top
            always-indicator
            do-not-disturb-while-screen-sharing-or-recording
            native-window-placement
            weather-oclock
            night-theme-switcher

            cronomix

            #net-speed-simplified
            #tophat

            executor
            upower-battery
            shutdowntimer
            wiggle
            blur-my-shell
            caffeine
            bing-wallpaper-changer
            hibernate-status-button
            auto-move-windows

            arcmenu
            workspace-indicator
            gtk4-desktop-icons-ng-ding
            panel-world-clock-lite
          ];

          dconf =
            let
              rawGvariant = str: {
                _type = "gvariant";
                type = "";
                value = null;
                __toString = _: str;
              };
            in
            {
              # Style
              "org/gnome/desktop/background" = {
                primary-color = "#26a269";
                secondary-color = "#000000";
              };

              "org/gnome/shell" = {
                enabled-extensions = map (p: p.extensionUuid) config.prefstore.home.pokon548.gnome.extension;
                favorite-apps = lib.mkBefore [
                  "librewolf.desktop"
                  "org.gnome.Console.desktop"
                  "obsidian.desktop"
                  "codium.desktop"
                  "org.gnome.Nautilus.desktop"
                ];
              };

              "org/gnome/nautilus/icon-view" = {
                default-zoom-level = "small";
              };

              "org/gnome/desktop/interface" = {
                clock-show-weekday = true;
                clock-format = "12h";
                show-battery-percentage = true;
                text-scaling-factor = 1.1200000000000001;
              };

              "org/gnome/nautilus/preferences" = {
                click-policy = "single";
              };

              "org/gnome/Solanum" = {
                lap-length = lib.gvariant.mkUint32 45;
                sessions-until-long-break = lib.gvariant.mkUint32 3;
              };

              "org/gnome/shell/extensions/emoji-copy" = {
                always-show = false;
              };

              "org/gnome/shell/extensions/bingwallpaper" = {
                hide = true;
              };

              "org/gnome/shell/extensions/blur-my-shell/panel" = {
                blur = true;
                brightness = 0.75;
                force-light-text = false;
                override-background = true;
                style-panel = 0;
                override-background-dynamically = true;
                unblur-in-overview = true;
              };

              "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
                compatibility = true;
              };

              "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
                blur-original-panel = true;
              };

              "org/gnome/shell/extensions/blur-my-shell/overview" = {
                blur = true;
              };

              "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
                blur = false;
              };

              "org/gnome/shell/extensions/blur-my-shell/applications" = {
                blur = true;
                brightness = 1.0;
                dynamic-opacity = true;
                opacity = 180;
              };

              "org/gnome/shell/extensions/shutdowntimer-deminder" = {
                shutdown-mode-value = "Hibernate";
                show-end-session-dialog-value = true;
                shutdown-ref-timer-value = "22:30";
                shutdown-slider-value = 0.0;
                auto-wake-value = true;
                wake-ref-timer-value = "06:00";
                wake-slider-value = 0.0;
                show-wake-items-value = true;
              };

              "org/gnome/settings-daemon/plugins/power" = {
                sleep-inactive-ac-type = "nothing";
                sleep-inactive-battery-type = "hibernate";  # Sometimes suspend cause kernel panic. So disabled it for good
                power-button-action = "hibernate";
              };

              "org/gnome/shell/extensions/executor" = {
                left-active = true;
                left-index = 1;
                left-commands-json = builtins.toJSON {
                  commands = [
                    {
                      isActive = true;
                      command = ''echo "今年已过 $(($(date +%j)*100/365))%"'';
                      interval = 3600;
                      uuid = "86c85325-5d9b-4578-aca6-96c2bc698ef7";
                    }
                  ];
                };
                center-active = false;
                right-active = false;
              };

              "com/adrienplazas/Metronome" = {
                beats-per-minute = lib.gvariant.mkUint32 20;
                beats-per-bar = lib.gvariant.mkUint32 4;
              };

              "com/rafaelmardojai/Blanket" = {
                active-preset = "e3a69a28-e8bc-402d-8c29-388f19d8b301";
                background-playback = true;
              };

              "com/rafaelmardojai/Blanket/e3a69a28-e8bc-402d-8c29-388f19d8b301" = {
                visible-name = "Peace";
                sounds-volume = builtins.toJSON {
                  rain = 0.57;
                  storm = 0.29;
                  wind = 1.0;
                  waves = 0.38;
                  stream = 0.54;
                };
              };

              "org/gnome/desktop/datetime" = {
                automatic-timezone = true;
              };

              "org/gnome/mutter" = {
                experimental-features = [
                  "scale-monitor-framebuffer"
                  "xwayland-native-scaling"
                ];
              };

              "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
                sunset = ''gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark" && gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-dark" && gsettings set org.gnome.desktop.interface cursor-theme "Simp1e-Adw-Dark"'';
                sunrise = ''gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3" && gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-light" && gsettings set org.gnome.desktop.interface cursor-theme "Simp1e-Adw"'';
              };

              "org/gnome/shell/extensions/nightthemeswitcher/cursor-variants" = {
                enabled = true;
                day = "Simp1e-Adw";
                night = "Simp1e-Adw-Dark";
              };

              "org/gnome/shell/extensions/weatherornot" = {
                position = "clock-left";
              };

              "org/gnome/mutter" = {
                dynamic-workspaces = false;
                workspaces-only-on-primary = false;
              };

              "org/gnome/desktop/wm/preferences" = {
                button-layout = "appmenu:minimize,maximize,close";
                num-workspaces = 10;
              };

              "org/gnome/shell/app-switcher" = {
                current-workspace-only = true;
              };

              "org/gnome/shell/extensions/dash-to-dock" = {
                multi-monitor = true;
                click-action = "focus-minimize-or-previews";
                isolate-monitors = true;
                custom-theme-shrink = true;
                transparency-mode = "DYNAMIC";
                running-indicator-style = "DOTS";
                show-mounts = false;
                show-trash = false;
                show-icons-emblems = false;
                show-show-apps-button = false;
              };

              "org/gnome/system/location" = {
                enabled = true;
              };

              "org/gnome/shell/extensions/world-clock" = {
                button-position = "LR";
                button-position2 = "LR";
                opaque = true;
              };

              "org/gnome/clocks" = {
                world-clocks = rawGvariant
                  "[{'location': <(uint32 2, <('New York', 'KNYC', true, [(0.71180344078725644, -1.2909618758762367)], [(0.71059804659265924, -1.2916478949920254)])>)>}, {'location': <(uint32 2, <('Coordinated Universal Time (UTC)', '@UTC', false, @a(dd) [], @a(dd) [])>)>}, {'location': <(uint32 2, <('Tokyo', 'RJTI', true, [(0.62191898430954862, 2.4408429589140699)], [(0.62282074357417661, 2.4391218722853854)])>)>}]";
              };

              "org/gnome/desktop/input-sources" = {
                xkb-options = [ "keypad:pointerkeys" ];
              };

              "org/gnome/shell/extensions/just-perfection" = {
                app-menu = false;
                accessibility-menu = false;
                calendar = false;
                events-button = false;
                theme = true;
                startup-status = 0;
                world-clock = true;
              };

              "org/gnome/desktop/wm/keybindings" = {
                switch-to-workspace-1 = [ "<Alt>z" ];
                switch-to-workspace-2 = [ "<Alt>x" ];
                switch-to-workspace-3 = [ "<Alt>c" ];
                switch-to-workspace-4 = [ "<Alt>a" ];
                switch-to-workspace-5 = [ "<Alt>s" ];
                switch-to-workspace-6 = [ "<Alt>d" ];
                switch-to-workspace-7 = [ "<Alt>q" ];
                switch-to-workspace-8 = [ "<Alt>w" ];
                switch-to-workspace-9 = [ "<Alt>e" ];
                switch-to-workspace-10 = [ "<Alt>r" ];

                move-to-workspace-1 = [ "<Alt><Super>z" ];
                move-to-workspace-2 = [ "<Alt><Super>x" ];
                move-to-workspace-3 = [ "<Alt><Super>c" ];
                move-to-workspace-4 = [ "<Alt><Super>a" ];
                move-to-workspace-5 = [ "<Alt><Super>s" ];
                move-to-workspace-6 = [ "<Alt><Super>d" ];
                move-to-workspace-7 = [ "<Alt><Super>q" ];
                move-to-workspace-8 = [ "<Alt><Super>w" ];
                move-to-workspace-9 = [ "<Alt><Super>e" ];
                move-to-workspace-10 = [ "<Alt><Super>r" ];

                move-to-workspace-left = [ "<Alt><Super>Left" ];
                move-to-workspace-right = [ "<Alt><Super>Right" ];

                switch-to-workspace-left = [ "<Alt>Left" ];
                switch-to-workspace-right = [ "<Alt>Right" ];
              };

              "org/gnome/shell/extensions/pip-on-top" = {
                stick = true;
              };

              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                name = "DND Quick Switch";
                binding = "<Super>z";
                command = "bash -c \"[[ $(gsettings get org.gnome.desktop.notifications show-banners) == 'false' ]] && gsettings set org.gnome.desktop.notifications show-banners true || gsettings set org.gnome.desktop.notifications show-banners false\"";
              };

              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
                name = "Disable Ctrl + B";
                binding = "<Control>b";
                command = "echo nop";
              };

              "org/gnome/shell/keybindings" = {
                show-screenshot-ui = [ "<Shift><Super>s" ];
              };

              "org/gnome/shell/extensions/kimpanel" = {
                vertical = true;
              };

              "org/gnome/desktop/remote-desktop/rdp" = {
                enable = true;
                view-only = true;
                screen-share-mode = "extend";
              };

              "org/gnome/shell/weather" = {
                automatic-location = true;
              };

              "org/gnome/shell/extensions/gsconnect/device/dac5f8a6d2077c46" = {
                paired = true;
              };

              "org/gnome/settings-daemon/plugins/color" = {
                night-light-enabled = true;
              };

              "com/raggesilver/BlackBox" = {
                font = "FiraCode Nerd Font weight=450 11";
                window-width = lib.gvariant.mkUint32 1366;
                window-height = lib.gvariant.mkUint32 768;
                remember-window-size = true;
              };

              "org/gnome/Console" = {
                use-system-font = false;
                custom-font = "FiraCode Nerd Font 11";
              };

              "org/gnome/shell/extensions/clipboard-history" = {
                display-mode = 3;
              };

              "org/gnome/shell/extensions/caffeine" = {
                toggle-shortcut = [ "<Super>x" ];
                restore-state = true;
                inhibit-apps = [ "chengla-electron.desktop" "obsidian.desktop" "rustdesk-bin.desktop" "todoist.desktop" "org.remmina.Remmina.desktop" "codium.desktop" ];
              };

              "org/gnome/shell/extensions/arcmenu" = {
                show-activities-button = false;
                menu-layout = "Windows";
              };

              "org/gnome/shell/extensions/quick-settings-avatar" = {
                avatar-position = 1;
                avatar-nobackground = false;
              };

              "org/gnome/shell/extensions/gtk4-ding" = {
                icon-size = "small";
              };

              /*"org/gnome/shell/extensions/netspeedsimplified" = {
              wpos = 1;
              wposext = 0;
              mode = 3;
              chooseiconset = 2;
              iconstoright = true;
              reverseindicators = true;
              lockmouseactions = true;
              systemcolr = true;
              shortenunits = true;
              refreshtime = 1.0;
              };*/

              "org/gnome/shell/extensions/auto-move-windows" = {
                application-list = [
                  "element-desktop.desktop:1"
                  "todoist.desktop:1"
                  "thunderbird.desktop:1"
                  "org.gnome.Settings.desktop:1"
                  "io.missioncenter.MissionCenter.desktop:1"
                  "org.gnome.tweaks.desktop:1"
                  "org.gnome.Shell.Extensions.desktop:1"
                  "com.github.wwmm.easyeffects.desktop:1"
                  "anki.desktop:2"
                  "chengla-linux-unofficial.desktop:2"
                  "geogebra.desktop:2"
                  "io.github.xiaoyifang.goldendict_ng.desktop:2"
                  "obsidian.desktop:2"
                  "android-studio-canary.desktop:3"
                  "codium.desktop:3"
                  "org.prismlauncher.PrismLauncher.desktop:4"
                  "steam.desktop:4"
                  "rustdesk.desktop:5"
                  "org.remmina.Remmina.desktop:5"
                  "virt-manager.desktop:6"
                  "io.gitlab.news_flash.NewsFlash.desktop:7"
                  "io.bassi.Amberol.desktop:8"
                  "com.rafaelmardojai.Blanket.desktop:8"
                  "bitwarden.desktop:9"
                  "org.keepassxc.KeePassXC.desktop:9"
                  "fr.romainvigier.MetadataCleaner.desktop:9"
                  "io.github.mpobaschnig.Vaults.desktop:9"
                ];
              };
            };
        };
      };

      user = {
        pokon548 = {
          enable = true;
        };
      };
    };
  };
}
