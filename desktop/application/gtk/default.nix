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
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
  };

  home.sessionVariables.GTK_THEME = "adw-gtk3";
}
