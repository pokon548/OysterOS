{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.system.virtualisation.virtualbox
    {
      virtualisation = {
        virtualbox.host = {
          enable = true;
        };
      };
    };
}
