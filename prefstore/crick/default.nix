{ pkgs
, config
, lib
, ...
}:
with lib;
{
  config.prefstore = {
    slogan = ''
      The world is a cruel and irrational place.
      
      I wanted something to believe in. Something to hold fast to.
      I want to extend a hand to the weak and cleave the wickedness from this world.
      I wish to be that sword for the people.

      Run 'nixos-helo' for the NixOS manual

    '';

    boot = {
      latestKernel = true;
      systemd = {
        enable = true;
      };
    };

    desktop = {
      font = true;
      im = true;
      gnome.enable = true;
    };

    system = {
      impermanence.enable = false;
      i18n = true;
      sudo.noPassword = true;
    };

    home.pokon548 = {
      noReleaseCheck = true;
      persistence = {
        directories = [
          "公共"
          "视频"
          "图片"
          "文档"
          "下载"
          "音乐"
          "桌面"
        ];
      };
      programs = {
        fish = {
          enable = true;
          shellAbbrs = {
            ll = "ls -l";
            gg = "vlc -I dummy \"/home/$(whoami)/音乐/[230301]OCTOPATH TRAVELER II Original Soundtrack[320K]/45.勝利のファンファーレ.mp3\" --run-time=17 vlc://quit 2> /dev/null &";
            mz = "vlc -I dummy \"/home/$(whoami)/音乐/[230301]OCTOPATH TRAVELER II Original Soundtrack[320K]/46.敗北のレクイエム.mp3\" vlc://quit 2> /dev/null &";
            up = "cd /etc/nixos && nix flake update && sudo nixos-rebuild switch";
          };
          functions = {
            fish_greeting = "";
            ma = ''
              set IP 192.168.1.147 192.168.1.143
              for i in $IP
                adb connect $i:$(nmap $i -p 37000-44000 | awk "/\/tcp/" | cut -d/ -f1)
              end
              for i in $(adb devices | awk '{print $1}' | grep 192)
                scrcpy -s $i -w -S &
              end
            '';
          };
          plugins = [
            {
              name = "sponge";
              src = pkgs.fetchFromGitHub {
                owner = "meaningful-ooo";
                repo = "sponge";
                rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
                hash = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
              };
            }
            {
              name = "tide";
              src = pkgs.fetchFromGitHub {
                owner = "IlanCosman";
                repo = "tide";
                rev = "1af8bf782cfea6c9da85716bd45c24adb3499556";
                hash = "sha256-oLD7gYFCIeIzBeAW1j62z5FnzWAp3xSfxxe7kBtTLgA=";
              };
            }
            {
              name = "virtualfish";
              src = pkgs.fetchFromGitHub {
                owner = "justinmayer";
                repo = "virtualfish";
                rev = "3f0de6e9a41d795237beaaa04789c529787906d3";
                hash = "sha256-M4IzmQHELh7A9ZcnNCXSuMk0x71wxeTR35bpDVZDqiw=";
              };
            }
            {
              name = "gitnow";
              src = pkgs.fetchFromGitHub {
                owner = "joseluisq";
                repo = "gitnow";
                rev = "aba9145cd352598b01aa2a41844c55df92bc6b3b";
                hash = "sha256-y2Mv7ArVNziGx2lTMCZv//U1wbi4vky4Ni95Qt1YRWY=";
              };
            }
          ];
        };

        nix-index = {
          enable = true;
          enableFishIntegration = true;
        };
      };
      file = {
        ".config/VSCodium/User/settings.json".text = builtins.toJSON {
          "window.dialogStyle" = "custom";
          "window.titleBarStyle" = "custom";
          "workbench.iconTheme" = "vscode-icons";
          "security.workspace.trust.enabled" = false;
          "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace";
          "window.zoomLevel" = 0.5;
          "todo-tree.general.tags" = [
            "BUG"
            "HACK"
            "FIXME"
            "TODO"
            "XXX"
          ];
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[jsonc]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[json]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[html]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "window.commandCenter" = false;
          "git.enableCommitSigning" = true;
        };
      };
      application = {
        base = with pkgs; [
          vim
          sudo
        ];

        gnome-extra = with pkgs; [
          amberol
          abiword
          authenticator
          bottles
          blanket
          celluloid
          eyedropper
          gnome.gnome-tweaks
          mission-center
          drawing
          metadata-cleaner
          gnome-solanum
          gnome-frog
          newsflash
          tela-circle-icon-theme
          easyeffects
          remmina
          kooha
          gocryptfs
          nur.repos.pokon548.vaults
          nur.repos.pokon548.flowtime
          nur.repos.pokon548.sticky
          rnote
        ];

        office = with pkgs; [
          libreoffice-fresh
        ];

        internet = with pkgs; [
          thunderbird
          transmission_4-gtk
          librewolf
          ungoogled-chromium
          localsend
          element-desktop
          telegram-desktop
          freetube
        ] ++ (with config.prefstore.desktop.application; [
          qq
        ]);

        knowledge = with pkgs; [
          anki-bin
          koreader
          nur.repos.pokon548.chengla-electron
          obsidian
          goldendict-ng
          zotero_7
        ];

        development = with pkgs; [
          androidStudioPackages.canary
          android-tools
          godot_4
          scrcpy
        ] ++ (with config.prefstore.desktop.application; [
          vscodium
        ]);

        game = with pkgs; [
          (steam.override {
            extraPkgs = pkgs: [ openssl_1_1 ];
          })
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
            num-workspaces = 10;
          };

          "org/gnome/shell/app-switcher" = {
            current-workspace-only = true;
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            show-mounts = false;
            show-trash = false;
            show-show-apps-button = true;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            app-menu = false;
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
            automatic-location = false;
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
      nixostest.enable = true;
      pokon548 = {
        enable = false;
      };
    };
  };
}
