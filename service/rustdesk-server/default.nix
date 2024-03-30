{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.service.rustdesk-server.enable
  # TODO: Add ssh keypairs to config
    {
      services.rustdesk-server = {
        enable = true;
        relayIP = "pokon548.ink:21117";
        openFirewall = true;
      };
    };
}
