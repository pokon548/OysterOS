{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      drawing
    ];
  };
}
