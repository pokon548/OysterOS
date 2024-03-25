{ pkgs
, config
, lib
, application
, ...
}:
with lib;
{
  config.prefstore = {
    # TODO: partitio prefstore is currently broken. Needed to be fixed soon ™
    slogan = ''
      I'll be back once I eliminate that devil called poverty from the world!

      Run 'nixos-helo' for the NixOS manual

    '';

    timeZone = "Asia/Shanghai";

    boot = {
      latestKernel = true;
      secureboot = true;
      systemd = {
        enable = true;
      };
    };

    desktop = {
      font = true;
      im = true;
      gnome.enable = true;
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
          "application/pdf" = "org.gnome.Evince.desktop";
        };
      };
    };

    system = {
      impermanence.enable = true;
      i18n = true;
      sudo.noPassword = true;
      sysrq = true;
      tpm = true;
      virtualisation.virtualbox = true;
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
          qq
        ];

        knowledge = with application; [
          anki-bin
          koreader
          chengla-electron
          obsidian
          goldendict-ng
          zotero
        ];

        development = with application; [
          android-studio-canary
          android-tools
          vscodium
        ];

        game = with application; [
          steam
          prismlauncher
        ];
      };
      gnome = {
        extension = with pkgs.gnomeExtensions; [
          gsconnect
          appindicator
          dash-to-dock
          kimpanel

          clipboard-history
          emoji-copy
          just-perfection
          pip-on-top
          unmess
          always-indicator
          do-not-disturb-while-screen-sharing-or-recording
          native-window-placement
          weather-oclock
          night-theme-switcher

          net-speed-simplified
          tophat

          upower-battery

          blur-my-shell
          caffeine
          bing-wallpaper-changer
          hibernate-status-button
          user-avatar-in-quick-settings
        ];

        dconf = {
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

          "org/gnome/shell/extensions/nightthemeswitcher/gtk-variants" = {
            enabled = true;
            day = "adw-gtk3";
            night = "adw-gtk3-dark";
          };

          "org/gnome/shell/extensions/nightthemeswitcher/icon-variants" = {
            enabled = true;
            day = "Tela-circle-light";
            night = "Tela-circle-dark";
          };

          "org/gnome/shell/extensions/nightthemeswitcher/cursor-variants" = {
            enabled = true;
            day = "Simp1e-Adw";
            night = "Simp1e-Adw-Dark";
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
            running-indicator-style = "DOTS";
            show-mounts = false;
            show-trash = false;
            show-show-apps-button = true;
          };

          "org/gnome/system/location" = {
            enabled = true;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            app-menu = false;
            accessibility-menu = false;
            calendar = false;
            events-button = false;
            theme = true;
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

          "org/gnome/shell/keybindings" = {
            show-screenshot-ui = [ "<Shift><Super>s" ];
          };

          "org/gnome/shell/extensions/kimpanel" = {
            vertical = true;
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

          "org/gnome/shell/extensions/quick-settings-avatar" = {
            avatar-position = 1;
            avatar-nobackground = false;
          };

          "org/gnome/shell/extensions/netspeedsimplified" = {
            wpos = 1;
            mode = 3;
            chooseiconset = 2;
            iconstoright = true;
            reverseindicators = true;
            lockmouseactions = true;
            systemcolr = true;
            shortenunits = true;
            refreshtime = 1.0;
          };

          "org/gnome/shell/extensions/unmess" = {
            classgroup = builtins.toJSON {
              SchildiChat = 1;
              Element = 1;
              Todoist = 1;
              thunderbird = 1;
              "org.gnome.Settings" = 1;
              "io.missioncenter.MissionCenter" = 1;
              gnome-tweaks = 1;
              "org.gnome.Extensions" = 1;
              "com.github.wwmm.easyeffects" = 1;

              Anki = 2;
              chengla-linux-unofficial = 2;
              "draw.io" = 2;
              Geogrebra = 2;
              GoldenDict-ng = 2;
              Obsidian = 2;

              "Android Studio" = 3;
              Vscodium = 3;
              Godot = 3;
              "ida64.exe" = 3;

              "org.prismlauncher.PrismLauncher" = 4;
              "hu.kramo.Cartridges" = 4;
              Steam = 4;
              steamwebhelper = 4;

              Rustdesk = 5;
              "org.remmina.Remmina" = 5;

              virt-manager = 6;
              Qemu-system-x86_64 = 6;
              "VirtualBox Manager" = 6;

              "io.gitlab.news_flash.NewsFlash" = 7;

              "io.bassi.Amberol" = 8;
              "com.rafaelmardojai.Blanket" = 8;
              FreeTube = 8;

              Bitwarden = 9;
              KeePassXC = 9;
              "fr.romainvigier.MetadataCleaner" = 9;
              "io.github.mpobaschnig.Vaults" = 9;

              ".scrcpy-wrapped" = 10;
            };

            classinstance = builtins.toJSON {
              schildichat = 1;
              element = 1;
              todoist = 1;
              thunderbird = 1;
              "org.gnome.Settings" = 1;
              "io.missioncenter.MissionCenter" = 1;
              gnome-tweaks = 1;
              "org.gnome.Extensions" = 1;
              "com.github.wwmm.easyeffects" = 1;

              anki = 2;
              chengla-linux-unofficial = 2;
              "draw.io" = 2;
              geogrebra = 2;
              goldenDict = 2;
              obsidian = 2;

              android-studio-canary = 3;
              vscodium = 3;
              Godot_ProjectList = 3;
              "ida64.exe" = 3;

              "org.prismlauncher.PrismLauncher" = 4;
              "hu.kramo.Cartridges" = 4;
              steam = 4;
              steamwebhelper = 4;

              rustdesk = 5;
              "org.remmina.Remmina" = 5;

              virt-manager = 6;
              qemu = 6;
              "VirtualBox Manager" = 6;

              "io.gitlab.news_flash.NewsFlash" = 7;

              "io.bassi.Amberol" = 8;
              "com.rafaelmardojai.Blanket" = 8;
              freetube = 8;

              bitwarden = 9;
              keepassxc = 9;
              "fr.romainvigier.MetadataCleaner" = 9;
              "io.github.mpobaschnig.Vaults" = 9;

              ".scrcpy-wrapped" = 10;
            };
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
}
