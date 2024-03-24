{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      nur.repos.pokon548.vaults
      gocryptfs
    ];
  };
}
