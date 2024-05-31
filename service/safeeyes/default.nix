{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.service.safeeyes.enable { 
    services.safeeyes.enable = true;
  };
}
