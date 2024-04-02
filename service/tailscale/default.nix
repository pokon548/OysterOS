{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.service.tailscale.enable
    {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        authKeyFile = config.prefstore.service.tailscale.authKeyFile;
        extraUpFlags = "--login-server https://${config.prefstore.system.network.domain.headscale}";
      };
    };
}
