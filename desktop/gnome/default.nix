{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.desktop.gnome.enable
    {
      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        excludePackages = [ pkgs.xterm ];
      };

      nixpkgs.overlays = [
        (self: super: {
          gnome = super.gnome.overrideScope' (gself: gsuper: {
            mutter = gsuper.mutter.overrideAttrs (old: {
              patches = [
                ./patch/mutter/mr1441.patch
                ./patch/mutter/mr3373.patch
                ./patch/mutter/mr3729.patch
                ./patch/mutter/mr3751.patch
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

      # TODO: Workaround for gdm crash issue, see https://github.com/NixOS/nixpkgs/issues/103746
      systemd.services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
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
          GSK_RENDERER = "gl";
        };

        # Fix qt program not showing tray under gnome. See https://github.com/NixOS/nixpkgs/issues/255736
        extraInit = ''
          unset QT_QPA_PLATFORMTHEME
        '';
        gnome.excludePackages =
          (with pkgs;
          [
            baobab
            gnome-tour
            tracker-miners
            tracker
            evince
          ])
          ++ (with pkgs.gnome; [
            cheese
            gnome-calendar
            gnome-music
            gnome-contacts
            gnome-maps
            gnome-disk-utility
            gnome-logs
            gnome-system-monitor
            gnome-font-viewer
            epiphany
            simple-scan
            geary
            yelp
            seahorse
            gnome-characters
            totem
          ]);
      };
    };
}
