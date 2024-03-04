{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.boot.secureboot
    {
      # NOTE: Currently, I do not have enough knowledge and time to all-in all
      #       security related enhancements. It is not practicable.
      #
      #       However, focusing on integrity for boot and kernel components is possible.

      # Secure boot
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/persist/etc/secureboot";
      };
    };
}
