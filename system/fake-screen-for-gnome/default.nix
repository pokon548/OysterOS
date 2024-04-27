{ lib
, config
, pkgs
, ...
}:
{
  config = lib.mkIf config.prefstore.desktop.gnome.fakeScreen.enable
    {
      # Not gonna consider X11 users because this is only supported on Wayland :)
      systemd.user.services."org.gnome.Shell@wayland" = {
        serviceConfig = {
          Environment = [
            ""
          ];
          ExecStart = [
            ""
            "${pkgs.gnome.gnome-shell}/bin/gnome-shell --virtual-monitor ${config.prefstore.desktop.gnome.fakeScreen.resolution}"
          ];
        };
      };
    };
}
