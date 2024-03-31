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
      name = "微信";
      desktopName = "微信";
      exec = "wechat-uos %U";
      terminal = false;
      icon = "wechat";
      type = "Application";
      categories = [ "Utility" ];
      comment = "微信桌面（沙盒）版";
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
              appId = "com.tencent.mm";
            };
            bubblewrap = {
              bind.rw = [
                [
                  (sloth.mkdir (sloth.concat [ sloth.xdgDocumentsDir "/WeChat_Data" ]))
                  (sloth.concat' sloth.homeDir "/xwechat_files")
                ]
              ];
              bind.ro = [
                # Absolutely required. Missing any of them will cause you not able to launch wechat
                "/etc/fonts"
                "/etc/machine-id"
                "/etc/localtime"
                "/etc/passwd"

                # Certificates. Required for SSL connections. Kind of optional
                "/etc/ssl/certs/ca-bundle.crt"
                "/etc/ssl/certs/ca-certificates.crt"
                "/etc/pki/tls/certs/ca-bundle.crt"

                # Will read, but optional
                #"/etc/hosts"
                #"/etc/host.conf"
                #"/etc/resolv.conf"
                #"/etc/nsswitch.conf"
                #"/etc/group"
                #"/etc/shadow"
                #"/etc/profiles"
                #"/etc/sudoers.d"
                #"/etc/sudoers"
                #"/etc/zoneinfo"
                #"/etc/asound.conf"

                #"/sys/dev/char"
                #"/sys/devices"
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
                "/dev/video0"
                "/dev/video1"
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
              package = pkgs.wechat-uos;
              binPath = "bin/wechat-uos";
            };
          };
        }).config.script
    ];
    global-persistence.directories = [ "Documents/WeChat_Data" ];
  };
}
