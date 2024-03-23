{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      keepassxc
    ];

    global-persistence.directories = [
      ".config/keepassxc"
    ];
  };
}
