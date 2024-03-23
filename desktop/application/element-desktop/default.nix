{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      element-desktop
    ];

    global-persistence.directories = [
      ".config/Element"
    ];
  };
}
