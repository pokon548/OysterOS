{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      easyeffects
    ];

    global-persistence.directories = [
      ".config/easyeffects"
    ];
  };
}
