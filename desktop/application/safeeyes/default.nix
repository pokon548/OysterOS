{ pkgs
, config
, ...
}:
{
  home = {
    global-persistence.directories = [
      ".config/safeeyes"
    ];
  };
}
