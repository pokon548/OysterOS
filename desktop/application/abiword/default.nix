{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      abiword
    ];
  };
}
