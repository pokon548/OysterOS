{ config
, ...}:
{
  home = {
    directories = [
      ".config/goldendict"
      ".local/share/goldendict"
    ];
  };
}