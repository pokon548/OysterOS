{ lib
, inputs
, ...
}: {
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
}
