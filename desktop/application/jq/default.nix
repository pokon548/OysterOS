{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      jq
    ];
  };
}
