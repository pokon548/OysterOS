{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.service.headscale.enable
    # TODO: Not finished yet
    {
      services.headscale = {
        enable = true;
        port = config.prefstore.system.network.port.headscale;
        settings = {
          server_url = "https://${config.prefstore.system.network.domain.headscale}";
          metrics_listen_addr = "127.0.0.1:9090";

          grpc_listen_addr = "127.0.0.1:50443";
          grpc_allow_insecure = false;

          private_key_path = config.prefstore.service.headscale.private_key_path;
          noise.private_key_path = config.prefstore.service.headscale.noise.private_key_path;

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

      services.caddy.virtualHosts."${config.prefstore.system.network.domain.headscale}" = {
        extraConfig = ''
          tls me@${config.prefstore.system.network.domain.headscale}
          header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
          encode zstd gzip
          handle {
            reverse_proxy localhost:${builtins.toString config.prefstore.system.network.port.headscale}
          }
        '';
      };
    };
}
