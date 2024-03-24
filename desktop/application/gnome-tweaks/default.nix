{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      gnome.gnome-tweaks
    ];
  };
}
