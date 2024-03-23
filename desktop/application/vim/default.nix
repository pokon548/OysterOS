{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      vim
    ];

    global-persistence.directories = [
      ".vim"
    ];
  };
}
