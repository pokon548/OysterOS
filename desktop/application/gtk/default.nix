{ pkgs
, config
, ...
}:
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Simp1e-Adw";
      package = pkgs.simp1e-cursors;
    };
    font = {
      name = "Cantarell Regular";
      package = pkgs.cantarell-fonts;
      size = 11;
    };
    iconTheme = {
      name = "Tela-circle-light";
      package = pkgs.tela-circle-icon-theme;
    };
    theme = {
      name = "Adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
}
