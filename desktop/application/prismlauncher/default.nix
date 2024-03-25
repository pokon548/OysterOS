{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      prismlauncher

      zulu8
    ];

    global-persistence.directories = [
      ".local/share/PrismLauncher"
    ];
  };
}
