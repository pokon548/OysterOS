{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      bottles
    ];

    global-persistence.directories = [
      ".local/share/bottles"
    ];
  };
}
