{
  inputs = {
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lts.url = "https://channels.ctrl-os.com/channel/ctrlos-26.05.tar.xz";

    sops-nix-unstable = {
      url = "github:Mic92/sops-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix-lts = {
      url = "github:Mic92/sops-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };
    disko-unstable = {
      url = "github:AlexLov/disko?rev=6747342da148f6cb28c8405a70fe00455a0ba027&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko-lts = {
      url = "github:nix-community/disko?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };

    nixverse = {
      url = "github:hgl/nixverse?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # NixOS Hardware
    hardware-unstable = {
      url = "github:NixOS/nixos-hardware?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hardware-lts = {
      url = "github:NixOS/nixos-hardware?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };
  };

  outputs =
    inputs@{ nixverse, ... }:
    nixverse.lib.load {
      inherit inputs;
      flakePath = ./.;
    };
}
