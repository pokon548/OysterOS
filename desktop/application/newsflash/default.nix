{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      newsflash
    ];

    global-persistence.directories = [
      ".local/share/news_flash"
      ".local/share/news-flash"
    ];
  };
}
