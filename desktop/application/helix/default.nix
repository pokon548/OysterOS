{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      helix
    ];

    global-persistence.directories = [
      ".config/helix"
    ];
  };
}
