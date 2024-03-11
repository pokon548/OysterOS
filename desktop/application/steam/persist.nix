{ config
, ...}:
{
  home = {
    directories = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}