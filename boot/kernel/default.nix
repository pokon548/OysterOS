{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.boot.latestKernel
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
