{ inputs
, lib
, config
, pkgs
, ...
}: {
  nixpkgs = {
    overlays = [
      inputs.nur.overlay
      inputs.nix-vscode-extensions.overlays.default

      (lib.mkIf config.prefstore.desktop.gnome.enable (self: super: {
        gnome = super.gnome.overrideScope' (gself: gsuper: {
          mutter = gsuper.mutter.overrideAttrs (old: {
            patches = [ ../desktop/gnome/patch/mutter/mr1441.patch ../desktop/gnome/patch/mutter/mr3327.patch ];
          });

          gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
            patches = old.patches ++ [
              ../desktop/gnome/patch/gnome-shell/no-screenshot-flash.patch
              ../desktop/gnome/patch/gnome-shell/no-workspace-animation.patch
              ../desktop/gnome/patch/gnome-shell/no-overview-animation.patch
              ../desktop/gnome/patch/gnome-shell/no-application-animation.patch
            ];
          });
        });
      }))
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-25.9.0"
      ];
    };
  };

  nix = {
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    gc = {
      automatic = true;
      options = "--delete-older-than 28d";
      dates = "daily";
    };

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://microvm.cachix.org"
        "https://pokon548.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "pokon548.cachix.org-1:fhQhJ1PubjdhjdqTUnUtvszMcYG4pSgyeVUWOOxKklM="
      ];
    };
  };
}
