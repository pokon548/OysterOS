{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      wpsoffice-cn
    ];

    global-persistence.directories = [
      ".config/Kingsoft"
      ".config/kingsoft"
    ];
  };
}
