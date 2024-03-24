{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      rnote
    ];
  };
}
