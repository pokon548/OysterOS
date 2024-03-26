{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      nur.repos.pokon548.geogebra
    ];

    global-persistence.directories = [
      ".config/GeoGebra"
    ];
  };
}
