{
  inputs = {
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lts.url = "https://channels.ctrl-os.com/channel/ctrlos-26.05.tar.xz";

    sops-nix-unstable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix-lts = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };
    disko-unstable = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko-lts = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };

    nixverse = {
      url = "github:hgl/nixverse";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ nixverse, ... }:
    nixverse.lib.load {
      inherit inputs;
      flakePath = ./.;
    };
}
