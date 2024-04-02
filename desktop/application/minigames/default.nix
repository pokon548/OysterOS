{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs.gnome; [
      gnome-mines
      gnome-sudoku
    ];
  };
}
