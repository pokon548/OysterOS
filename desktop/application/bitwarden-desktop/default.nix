{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      bitwarden-desktop
    ];

    global-persistence.directories = [
      ".config/Bitwarden"
    ];
  };
}