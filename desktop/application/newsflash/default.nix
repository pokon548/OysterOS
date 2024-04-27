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
      ".config/news-flash"
      ".local/share/news_flash"
      ".local/share/news-flash"
    ];
  };
}
