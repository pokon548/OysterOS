{ inputs
, lib
, config
, pkgs
, ...
}:
{
  nixpkgs = {
    overlays = with inputs; [
      nur.overlay
      microvm.overlay
      nix-vscode-extensions.overlays.default
      fenix.overlays.default

      (final: prev: {
        # TODO: Obsidian 1.5.8+ breaks IM inputs. See https://forum-zh.obsidian.md/t/topic/31360/8
        #
        # For useability issue, this package is rollbacked to 1.5.8.
        obsidian = prev.obsidian.overrideAttrs (_: rec {
          version = "1.5.8";

          src = final.fetchurl {
            url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
            hash = "sha256-oc2iA2E3ac/uUNv6unzfac5meHqQzmzDVl/M9jNpS/M=";
          };
        });
      })
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
      sandbox = false;
      trusted-users = [
        "pokon548"
      ];
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://microvm.cachix.org"
        "https://pokon548.cachix.org"
        "https://cache.garnix.io"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "pokon548.cachix.org-1:fhQhJ1PubjdhjdqTUnUtvszMcYG4pSgyeVUWOOxKklM="
      ];
    };
  };

  programs.command-not-found.enable = lib.mkForce false;
}
