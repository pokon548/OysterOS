{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.boot.grub.enable
    {
      boot.loader.grub = {
        enable = true;
      };
    };
}
