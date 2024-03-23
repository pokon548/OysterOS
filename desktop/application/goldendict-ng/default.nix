{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      goldendict-ng
    ];

    global-persistence.directories = [
      ".config/goldendict"
      ".local/share/goldendict"
    ];
  };
}
