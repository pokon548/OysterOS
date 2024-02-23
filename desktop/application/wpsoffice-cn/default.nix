{ mkNixPak
, pkgs
, ... }:

mkNixPak {
  config = { sloth, ... }: {
    dbus.policies = {
      "org.freedesktop.systemd1" = "talk";
      "org.gtk.vfs.*" = "talk";
      "org.gtk.vfs" = "talk";
    };
    bubblewrap = {
      bind.rw = [ sloth.homeDir ];
      network = false;
    };
    app.package = pkgs.wpsoffice-cn;
  };
}
