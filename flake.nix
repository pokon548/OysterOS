{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Haumea
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak-pkgs.url = "github:nixpak/pkgs";

    impermanence.url = "github:nix-community/impermanence";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";

    microvm.url = "github:astro/microvm.nix";

    minioyster.url = "github:pokon548/MiniOyster";
  };

  outputs = { self, ... } @ inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      flake.nixosConfigurations =
        let
          inherit (inputs.nixpkgs) lib;
        in
        lib.attrsets.genAttrs
          (lib.mapAttrsToList (name: value: name) (builtins.readDir ./prefstore))
          (name: lib.nixosSystem {
            specialArgs = { inherit inputs name; };
            modules = [
              # Nix
              ./nix

              # Preference Store
              ./prefstore
              (./. + ("/prefstore/" + name))

              # Machine Configuration
              (./. + ("/machine/" + name))

              # trustzone
              ./trustzone
            ] ++ (with inputs; [
              home-manager.nixosModules.home-manager
              impermanence.nixosModules.impermanence
              lanzaboote.nixosModules.lanzaboote
              (if name == "ritsu" then microvm.nixosModules.microvm else { })
              nix-index-database.nixosModules.nix-index
              nixos-generators.nixosModules.all-formats
              disko.nixosModules.disko
              sops-nix.nixosModules.sops
              nur.nixosModules.nur

              minioyster.nixosModules.minioyster
              minioyster.nixosModules."prefstore-${name}"
            ]) ++ builtins.concatLists
              (lib.forEach
                [
                  "boot"
                  "desktop"
                  "service"
                  "system"
                  "user"
                ]
                (x:
                  (lib.mapAttrsToList
                    (name: value: ./. + ("/" + toString x + "/" + name))
                    (builtins.readDir (./. + ("/" + toString x))))
                ));
          });

      systems = [ "x86_64-linux" ];
    };
}
