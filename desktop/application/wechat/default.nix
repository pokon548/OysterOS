{ lib
, config
, mkNixPak
, gui-base
, pkgs
, ...
}:
{
  # TODO: Fix wechat-uos in future
  home = {
    packages = [
      (mkNixPak
        {
          config = { sloth, ... }: {
            flatpak = {
              appId = "com.tencent.mm";
            };
            bubblewrap = {
              bind.rw = [
                (sloth.mkdir (sloth.concat [ sloth.xdgDocumentDir "/WeChat_Data" ]))
              ];
              bind.ro = [
                "/etc"
                "/sys/dev/char"
                "/sys/devices"
                [ "${coreutils}/bin/true" "/usr/bin/lsblk" ]
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
