{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      transmission_4-gtk
    ];

    global-persistence.directories = [
      ".config/transmission"
    ];
  };
}
