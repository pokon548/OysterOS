{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      libreoffice-fresh
    ];

    global-persistence.directories = [
      ".config/libreoffice"
    ];
  };
}
