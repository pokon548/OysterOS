{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      celluloid
    ];
  };
}
