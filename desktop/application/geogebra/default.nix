{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (mkWaylandApp nur.repos.pokon548.geogebra "geogebra" [
        "--enable-wayland-ime"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
      ])
    ];

    global-persistence.directories = [
      ".config/GeoGebra"
    ];
  };
}
