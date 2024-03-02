{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.system.sysrq
    {
      boot.kernel.sysctl = {
        "kernel.sysrq" = 1;
      };
    };
}
