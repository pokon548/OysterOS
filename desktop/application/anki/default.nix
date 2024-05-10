{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      anki-bin
    ];

    global-persistence.directories = [
      ".local/share/Anki2"
    ];
  };
}
