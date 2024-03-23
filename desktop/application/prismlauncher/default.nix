{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      prismlauncher
    ];

    global-persistence.directories = [
      ".local/share/PrismLauncher"
    ];
  };
}
