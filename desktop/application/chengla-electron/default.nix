{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      nur.repos.pokon548.chengla-electron
    ];

    global-persistence.directories = [
      ".config/chengla-linux-unofficial"
    ];
  };
}
