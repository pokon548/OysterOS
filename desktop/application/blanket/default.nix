{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      blanket
    ];
  };
}
