{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      remmina
    ];

    global-persistence.directories = [
      ".config/remmina"
    ];
  };
}
