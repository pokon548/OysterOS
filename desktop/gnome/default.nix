{ lib
, config
, pkgs
, ...
}:
let
  unstable = import
    (builtins.fetchTarball https://github.com/pokon548/nixpkgs/tarball/fix-valent-icon)
    { };
in
{
  config = lib.mkIf config.prefstore.desktop.gnome.enable
    {
      services = {
        xserver = {
          enable = true;
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;

          excludePackages = [ pkgs.xterm ];
        };
      };

      services.pipewire = {
        enable = true;
        audio.enable = true;
        pulse.enable = true;
      };

      services.geoclue2.geoProviderUrl = "https://geolocation.bukn.uk/geolocation/v1/geolocate";

      programs.nix-ld.enable = true;

      hardware.pulseaudio.enable = false;

      nixpkgs.overlays = [
        (self: super: {
          gnome = super.gnome.overrideScope' (gself: gsuper: {
            mutter = gsuper.mutter.overrideAttrs (old: {
              patches = [
                ./patch/mutter/mr1441.patch
                ./patch/mutter/mr3373.patch
                ./patch/mutter/mr3567.patch
                ./patch/mutter/mr3751.patch
              ];
            });

            gnome-settings-daemon = gsuper.gnome-settings-daemon.overrideAttrs (old: {
              patches = old.patches ++ [
                #./patch/gnome-settings-daemon/0001-subprojects-Update-gvc-to-latest-commit.patch
                ./patch/gnome-settings-daemon/0001-xsettings-Get-UI-scaling-factor-from-dedicated-D-Bus.patch
              ];
            });

            gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
              patches = old.patches ++ [
                ./patch/gnome-shell/mr3318.patch

                ./patch/gnome-shell/no-screenshot-flash.patch
                ./patch/gnome-shell/no-workspace-animation.patch
                ./patch/gnome-shell/no-overview-animation.patch
                ./patch/gnome-shell/no-application-animation.patch
              ];
            });
          });
        })
      ];

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita";
      };

      # GSConnect
      networking.firewall = {
        allowedTCPPortRanges = config.prefstore.system.network.port.kde-connect;
        allowedUDPPortRanges = config.prefstore.system.network.port.kde-connect;
      };

      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };

      # TODO: Workaround for gdm crash issue, see https://github.com/NixOS/nixpkgs/issues/103746
      systemd.services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;

        colord = {
          serviceConfig =
            {
              ExecStart = [
                ""
                "${pkgs.colord}/libexec/colord --verbose"
              ];
            };
        };
      };

      environment = {
        systemPackages = with pkgs; [
          adw-gtk3
          simp1e-cursors

          papers
          gnome-menus
        ];

        sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        # Fix qt program not showing tray under gnome. See https://github.com/NixOS/nixpkgs/issues/255736
        extraInit = ''
          unset QT_QPA_PLATFORMTHEME
        '';
        gnome.excludePackages =
          (with pkgs;
          [
            baobab
            cheese
            gnome-tour
            gnome-calendar
            gnome-disk-utility
            gnome-system-monitor
            gnome-font-viewer
            simple-scan
            epiphany
            geary
            yelp
            seahorse
            tracker-miners
            tracker
            totem
            evince
          ])
          ++ (with pkgs.gnome; [
            gnome-music
            gnome-contacts
            gnome-maps
            gnome-logs
            gnome-characters
          ]);
      };
    };
}
