{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.service.caddy.enable
    {
      services.caddy = {
        enable = true;
      };

      networking.firewall.allowedTCPPorts = [
        config.prefstore.system.network.port.https
      ];
    };
}
