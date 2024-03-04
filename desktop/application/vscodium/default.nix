{ lib
, config
, mkNixPak
, nixpakModules
, pkgs
, ...
}:
let
  commonExtensions = with pkgs.vscode-marketplace; [
    vscodevim.vim
    vscode-icons-team.vscode-icons
    ms-ceintl.vscode-language-pack-zh-hans
    github.vscode-pull-request-github
    jnoortheen.nix-ide
    arrterian.nix-env-selector
    gruntfuggly.todo-tree
    rust-lang.rust-analyzer
  ];
  shellScriptExtensions = with pkgs.vscode-marketplace; [
    foxundermoon.shell-format
  ];
  frontendDevExtensions = with pkgs.vscode-marketplace; [
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    bradlc.vscode-tailwindcss
    astro-build.astro-vscode
    #vunguyentuan.vscode-postcss
    ms-playwright.playwright
  ];
in
mkNixPak {
  config = { sloth, ... }: {
    bubblewrap = {
      bind.rw = [
        (sloth.mkdir (sloth.concat [ sloth.xdgConfigHome "/VSCodium" ]))
        (sloth.mkdir (sloth.concat [ sloth.xdgConfigHome "/.vscode-oss" ]))
        (sloth.mkdir (sloth.concat [ sloth.homeDir "/Programmings" ]))
      ];
      bind.ro = [
        "/etc/fonts"
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
      package = pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = commonExtensions ++ shellScriptExtensions ++ frontendDevExtensions;
      };
    };
  };
}
