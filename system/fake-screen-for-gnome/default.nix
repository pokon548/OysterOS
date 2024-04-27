{ lib
, config
, pkgs
, ...
}:
{
  config = lib.mkIf config.prefstore.desktop.gnome.fakeScreen.enable
    {
      xdg = {
        enable = true;
        configFile."systemd/user/org.gnome.Shell@wayland.service.d/override.conf".text = ''
          [Service]
          ExecStart=
          ExecStart=${pkgs.gnome.gnome-shell}/bin/gnome-shell --virtual-monitor ${config.prefstore.desktop.gnome.fakeScreen.resolution}
        '';
      };
    };
}
