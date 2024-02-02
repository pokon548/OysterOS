{ lib
, inputs
, ...
}: {
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];
}
