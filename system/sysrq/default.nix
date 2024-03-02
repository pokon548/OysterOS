{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.system.sudo.sysrq
    {
      boot.kernel.sysctl = {
        "kernel.sysrq" = 1;
      };
    };
}
