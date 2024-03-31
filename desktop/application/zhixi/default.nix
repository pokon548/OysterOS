{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
       	nur.repos.pokon548.zhixi
    ];

    global-persistence.directories = [
      ".config/zhiximind-desktop"
    ];
  };
}
