{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.boot.secureboot
    {
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/persist/etc/secureboot";
      };
    };
}
