{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      sudo
    ];
  };
}
