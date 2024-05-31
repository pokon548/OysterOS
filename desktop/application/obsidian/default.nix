{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (mkWaylandApp
        (obsidian.overrideAttrs (attrs: {
          src = pkgs.fetchurl {
            url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.3/obsidian-1.6.3.tar.gz";
            hash = "sha256-ho8E2Iq+s/w8NjmxzZo/y5aj3MNgbyvIGjk3nSKPLDw=";
          };
        })) "obsidian" [
        "--enable-wayland-ime"
      ])
    ];

    global-persistence.directories = [
      ".config/obsidian"
    ];
  };
}
