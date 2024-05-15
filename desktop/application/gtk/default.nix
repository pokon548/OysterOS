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
  };

  # Not writing this in gtk.theme due to runtime changes for schemes (light / night theme)!
  systemd.user.services.gtk-legacy-theme-setup = {
    Unit = {
      Description = "Automatically setup gtk3 legacy themes";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      TimeoutStartSec = 0;
      ExecStart = "${pkgs.writeShellScript "watch-store" ''
        #!/run/current-system/sw/bin/bash
        theme=$([[ `${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface color-scheme` =~ 'dark' ]] && echo "adw-gtk3-dark" || echo "adw-gtk3")
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme $theme
      ''}";
    };
  };
}
