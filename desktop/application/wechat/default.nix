{ lib
, config
, mkNixPak
, nixpakModules
, pkgs
, ...
}:

mkNixPak {
  config = { sloth, ... }: {
    flatpak = {
      appId = "com.tencent.qq";
    };
    bubblewrap = {
      bind.rw = [
        (sloth.concat [ sloth.xdgConfigHome "/QQ" ])
        (sloth.mkdir (sloth.concat [ sloth.xdgDownloadDir "/QQ" ]))
      ];
      bind.ro = [
        "/etc/fonts"
        "/usr"
        "/etc/machine-id"
        "/sys"
        "/etc/passwd"
        "/etc/nsswitch.conf"
        "/run/systemd/userdb"
        "/etc/resolv.conf"
        "/etc/localtime"
        "/proc"
        "/etc/nsswitch.conf"
        "/run/systemd/userdb/"
      ];
      network = true;
      sockets = {
        x11 = true;
        wayland = true;
        pipewire = true;
      };
      bind.dev = [
        "/dev"
        "/run/dbus"
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

    imports = [ nixpakModules.gui-base ];
    app = {
      package = (pkgs.qq.overrideAttrs (e: rec {
        # Update the install script to use the new .desktop entry
        installPhase = builtins.replaceStrings [ ''"$out/bin/qq"'' ] [ "qq" ] e.installPhase;
      }));
      binPath = "bin/qq";
    };
  };
}
