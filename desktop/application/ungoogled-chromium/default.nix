{ pkgs
, ...
}:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

  home = {
    global-persistence.directories = [ ".config/chromium" ];
  };
}
