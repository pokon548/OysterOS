{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      koreader
    ];

    global-persistence.directories = [
      ".config/koreader"
    ];
  };
}
