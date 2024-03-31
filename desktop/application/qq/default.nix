{ lib
, config
, mkNixPak
, gui-base
, pkgs
, ...
}:
{
  home = {
    packages = [
      (mkNixPak
        {
          config = { sloth, ... }: {
            flatpak = {
              appId = "com.tencent.qq";
            };
            dbus.policies = {
              "org.gnome.Shell.Screencast" = "talk";
              "org.freedesktop.Notifications" = "talk";
              "org.kde.StatusNotifierWatcher" = "talk";

              "org.freedesktop.portal.Documents" = "talk";
              "org.freedesktop.portal.Flatpak" = "talk";
              "org.freedesktop.portal.FileChooser" = "talk";
            };
            bubblewrap = {
              bind.rw = [
                (sloth.concat [ sloth.xdgConfigHome "/QQ" ])
                (sloth.mkdir (sloth.concat [ sloth.xdgDownloadDir "/QQ" ]))
              ];
              bind.ro = [
                "/etc/fonts"
                "/etc/machine-id"
                "/etc/localtime"
              ];
              network = true;
              sockets = {
                x11 = true;
                wayland = true;
                pipewire = true;
              };
              bind.dev = [
                "/dev/dri"
                "/dev/shm"
                "/run/dbus"
              ];
              tmpfs = [
                "/tmp"
              ];
              env = {
                IBUS_USE_PORTAL = "1";
                XDG_DATA_DIRS = lib.mkForce (lib.makeSearchPath "share" (with pkgs; [
                  adw-gtk3
                  tela-icon-theme
                  shared-mime-info
                ]));
                XCURSOR_PATH = lib.mkForce (lib.concatStringsSep ":" (with pkgs; [
                  "${tela-icon-theme}/share/icons"
                  "${tela-icon-theme}/share/pixmaps"
                  "${simp1e-cursors}/share/icons"
                  "${simp1e-cursors}/share/pixmaps"
                ]));
              };
            };

            imports = [ gui-base ];
            app = {
              package = (pkgs.qq.overrideAttrs (e: rec {
                # Update the install script to use the new .desktop entry
                installPhase = builtins.replaceStrings [ ''"$out/bin/qq"'' ] [ "qq" ] e.installPhase;
              }));
              binPath = "bin/qq";
            };
          };
        }).config.env
    ];
    global-persistence.directories = [ ".config/QQ" ];
  };
}
