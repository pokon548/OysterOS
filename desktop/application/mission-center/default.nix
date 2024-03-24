{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      mission-center
    ];
  };
}
