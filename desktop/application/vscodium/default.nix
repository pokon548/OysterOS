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
      appId = "com.vscodium.codium";
    };
    bubblewrap = {
      bind.rw = [
        (sloth.mkdir (sloth.concat [ sloth.xdgConfigHome "/VSCodium" ]))
        (sloth.mkdir (sloth.concat [ sloth.xdgConfigHome "/.vscode-oss" ]))
        (sloth.mkdir (sloth.concat [ sloth.homeDir "/Programmings" ]))
      ];
      network = true;
      sockets = {
        x11 = true;
        wayland = true;
        pulse = true;
      };
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
      package = (pkgs.vscode-with-extensions.overrideAttrs (e: rec {
        vscode = pkgs.vscodium;
      }));
    };
  };
}
