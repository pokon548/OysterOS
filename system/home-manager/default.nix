{ lib
, inputs
, ...
}: {
  home-manager.sharedModules = with inputs; [
    nix-index-database.hmModules.nix-index
    sops-nix.homeManagerModules.sops
    impermanence.nixosModules.home-manager.impermanence
  ] ++ [
    ./modules/global-persistence.nix
  ];
}
