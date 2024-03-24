{ lib
, config
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
    vunguyentuan.vscode-postcss
    ms-playwright.playwright
  ];
in
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    package = pkgs.vscodium;

    extensions = commonExtensions ++ shellScriptExtensions ++ frontendDevExtensions;
    userSettings = {
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
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
      "nix.serverSettings" = {
        "nil" = {
          "diagnostics" = {
            "ignored" = [ "unused_binding" "unused_with" ];
          };
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      nixpkgs-fmt
      nil

      jetbrains-mono
    ];

    global-persistence.directories = [ ".config/VSCodium" ];
  };
}
