{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.boot.systemd.enable
    {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
}
