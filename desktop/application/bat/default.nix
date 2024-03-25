{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      bat
    ];
  };
}
