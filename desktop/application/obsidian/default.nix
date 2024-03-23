{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      obsidian
    ];

    global-persistence.directories = [
      ".config/obsidian"
    ];
  };
}
