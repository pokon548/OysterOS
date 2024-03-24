{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      gnome-frog
    ];
  };
}
