{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (mkWaylandApp nur.repos.pokon548.chengla-electron "chengla-electron" [
        "--enable-wayland-ime"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
      ])
    ];

    global-persistence.directories = [
      ".config/chengla-linux-unofficial"
    ];
  };
}
