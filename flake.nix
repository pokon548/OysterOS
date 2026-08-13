{
  inputs = {
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lts.url = "https://channels.ctrl-os.com/channel/ctrlos-26.05.tar.xz";

    # Home manager
    home-manager-unstable = {
      url = "github:nix-community/home-manager?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-lts = {
      url = "github:nix-community/home-manager?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };

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

    preservation.url = "github:nix-community/preservation?shallow=1";

    noctalia-unstable = {
      url = "github:noctalia-dev/noctalia?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia-lts = {
      url = "github:noctalia-dev/noctalia?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-lts";
    };

    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix?shallow=1";
    };
  };

  outputs =
    inputs@{ nixverse, ... }:
    nixverse.lib.load {
      inherit inputs;
      flakePath = ./.;
    };
}
