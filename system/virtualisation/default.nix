{ lib
, config
, ...
}: {
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
  };

  config = lib.mkIf config.prefstore.system.virtualisation.virtualbox
    {
      virtualisation = {
        virtualbox.host = {
          enable = true;
        };
      };
    };
}
