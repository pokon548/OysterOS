{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.service.vaultwarden.enable
    {
      services.postgresql = {
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
      };

      services.vaultwarden = {
        enable = true;
        environmentFile = config.prefstore.service.vaultwarden.environmentFile;
        dbBackend = "postgresql";

        # NOTE: Some of the required configs are not set here. Please pass them in environmentFile:
        #
        # ADMIN_TOKEN
        # PUSH_INSTALLATION_ID
        # PUSH_INSTALLATION_KEY
        config = {
          domain = "https://${config.prefstore.system.network.domain.vaultwarden}";
          databaseUrl = "postgresql:///vaultwarden";
          signupsAllowed = false;

          rocketAddress = "127.0.0.1";
          rocketPort = config.prefstore.system.network.port.vaultwarden;
          rocketLog = "critical";

          iconService = "bitwarden";
          PUSH_ENABLED = true;
        };
      };

      systemd.services.vaultwarden = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };

      services.caddy.virtualHosts."${config.prefstore.system.network.domain.vaultwarden}" = {
        extraConfig = ''
          tls me@${config.prefstore.system.network.domain.vaultwarden}
          header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
          encode zstd gzip
          handle {
            reverse_proxy localhost:${builtins.toString config.prefstore.system.network.port.vaultwarden}
          }
        '';
      };
    };
}
