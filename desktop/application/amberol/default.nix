{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      amberol
    ];
  };
}
