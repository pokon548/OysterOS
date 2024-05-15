{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (mkWaylandApp element-desktop "element-desktop" [
        "--enable-wayland-ime"
      ])
    ];

    global-persistence.directories = [
      ".config/Element"
    ];
  };
}
