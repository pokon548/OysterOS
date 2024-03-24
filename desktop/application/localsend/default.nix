{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      localsend
    ];

    global-persistence.directories = [
      ".local/share/localsend_app"
    ];
  };
}
