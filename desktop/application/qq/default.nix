{ lib
, config
, mkNixPak
, gui-base
, pkgs
, ...
}:
let
  desktopItem = pkgs.makeDesktopItem
    {
      name = "qq";
      desktopName = "QQ";
      exec = "qq %U";
      terminal = false;
      icon = "qq";
      type = "Application";
      categories = [ "Utility" ];
      comment = "QQ 沙盒版";
    };
in
{
  home = {
    packages = [
      desktopItem
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
              package = with pkgs; (mkWaylandApp qq "qq" [
                "--enable-wayland-ime"
              ]);
              binPath = "bin/qq";
            };
          };
        }).config.script
    ];
    global-persistence.directories = [ ".config/QQ" ];
  };
}
