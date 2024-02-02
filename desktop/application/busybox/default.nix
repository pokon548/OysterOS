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
      bind.ro = [ (sloth.concat' sloth.homeDir "Documents") ];
      env = {
        TEST = "This is an environment variable test";
        PATH = "${pkgs.busybox}/bin";
      };
    };
    app.package = pkgs.busybox;
  };
}
