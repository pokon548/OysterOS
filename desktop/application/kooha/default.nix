{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      kooha
    ];
  };
}
