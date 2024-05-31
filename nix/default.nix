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
        mkWaylandApp =
          t: e: f:
          prev.stdenv.mkDerivation {
            pname = t.pname or t.name + "-mkWaylandApp";
            inherit (t) version;
            unpackPhase = "true";
            doBuild = false;
            nativeBuildInputs = [ prev.buildPackages.makeWrapper ];
            installPhase = ''
              mkdir -p $out/bin
              ln -s "${prev.lib.getBin t}/bin/${e}" "$out/bin"
              ln -s "${prev.lib.getBin t}/share" "$out/share"
            '';
            postFixup = ''
              for e in $out/bin/*; do
                wrapProgram $e --add-flags ${prev.lib.escapeShellArg f}
              done
            '';
          };
      })
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-27.3.11"
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
        "https://cosmic.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "pokon548.cachix.org-1:fhQhJ1PubjdhjdqTUnUtvszMcYG4pSgyeVUWOOxKklM="
      ];
    };
  };

  system.switch = {
    enable = false;
    enableNg = true;
  };

  programs.command-not-found.enable = lib.mkForce false;
}
