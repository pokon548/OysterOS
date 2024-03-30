{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      anki
    ];

    global-persistence.directories = [
      ".local/share/Anki2"
    ];
  };
}
