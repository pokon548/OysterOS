{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      thunderbird
    ];

    global-persistence.directories = [
      ".thunderbird"
    ];
  };
}
