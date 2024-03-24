{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      metadata-cleaner
    ];
  };
}
