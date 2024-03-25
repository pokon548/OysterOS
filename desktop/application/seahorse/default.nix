{ pkgs
, config
, ...
}:
{
  home = {
    global-persistence.directories = [
      ".local/share/keyrings"
    ];
  };
}
