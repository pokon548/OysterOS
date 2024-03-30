{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.service.headscale.enable
    # TODO: Not finished yet
    {
      services.postgresql = {
        ensureDatabases = [ "headscale" ];
        ensureUsers = [
          {
            name = "headscale";
            ensureDBOwnership = true;
          }
        ];
      };

      services.headscale = {
        enable = true;
        settings = {
          server_url = "https://derper-private.pokon548.ink";
          listen_addr = "127.0.0.1:${config.prefstore.system.network.port.headscale}";
          metrics_listen_addr = "127.0.0.1:9090";

          grpc_listen_addr = "127.0.0.1:50443";
          grpc_allow_insecure = false;

          private_key_path = ""; # TODO: Fill out path
          noise.private_key_path = ""; #TODO: Fill out this path

          ip_prefixes = [
            "100.64.0.0/10"
          ];

          derp = {
            server = {
              enabled = true;
              region_id = 999;
              region_code = "headscale";
              region_name = "Headscale Embedded DERP";
              stun_listen_addr = "0.0.0.0:23089";
            };
            path = [ ];
            auto_update_enabled = true;
            update_frequency = "24h";
          };

          disable_check_updates = true;
          ephemeral_node_inactivity_timeout = "30m";
          node_update_check_interval = "10s";

          db_type = "postgres";
          db_host = "localhost";
          db_name = "headscale";
          db_user = "headscale";

          dns_config = {
            override_local_dns = false;
            domains = [ ];
            magic_dns = false;
            base_domain = "machine.pokon548";
          };
        };
      };

      systemd.services.headscale = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };
    };
}
