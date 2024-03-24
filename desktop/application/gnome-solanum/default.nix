{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      gnome-solanum
    ];

    global-persistence.directories = [
      ".local/share/gnome-pomodoro"
    ];
  };
}
