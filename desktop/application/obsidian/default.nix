{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (mkWaylandApp obsidian "obsidian" [
        "--enable-wayland-ime"
      ])
    ];

    global-persistence.directories = [
      ".config/obsidian"
    ];
  };
}
