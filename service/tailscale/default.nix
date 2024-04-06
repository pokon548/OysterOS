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
      };
      systemd.services.tailscale-setup = {
        script = ''
          sleep 10

          if tailscale status; then
            echo "tailscale already up, skip"
          else
            echo "tailscale down, login using auth key"
            tailscale up --login-server https://${config.prefstore.system.network.domain.headscale} --auth-key "file:${config.prefstore.service.tailscale.authKeyFile}"
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = [ config.services.tailscale.package ];
        after = [ "tailscaled.service" ];
        requiredBy = [ "tailscaled.service" ];
      };
    };
}
