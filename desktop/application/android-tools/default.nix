{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      android-tools
    ];

    global-persistence.directories = [
      ".android"
    ];
  };
}
