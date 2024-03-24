{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      eyedropper
    ];
  };
}
