{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      authenticator
    ];

    global-persistence.directories = [
      ".local/share/authenticator"
    ];
  };
}