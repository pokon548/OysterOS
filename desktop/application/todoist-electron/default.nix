{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (mkWaylandApp nur.repos.pokon548.todoist-electron "todoist-electron" [
        "--enable-wayland-ime"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
      ])
    ];

    global-persistence.directories = [
      ".config/Todoist"
    ];
  };
}
