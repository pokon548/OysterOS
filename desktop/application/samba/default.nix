{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      samba4Full
    ];
  };
}
