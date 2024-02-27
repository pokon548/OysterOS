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
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = nixpkgs.lib.attrsets.genAttrs
        (nixpkgs.lib.mapAttrsToList (name: value: name) (builtins.readDir ./prefstore))
        (name: nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs name; };
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
            nixos-generators.nixosModules.all-formats
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            nur.nixosModules.nur
          ]) ++ builtins.concatLists
            (nixpkgs.lib.forEach
              [
                "boot"
                "desktop"
                "service"
                "system"
                "user"
              ]
              (x:
                (nixpkgs.lib.mapAttrsToList
                  (name: value: ./. + ("/" + toString x + "/" + name))
                  (builtins.readDir (./. + ("/" + toString x))))
              ));
        });
    };
}
