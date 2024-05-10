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
          status=$(${config.systemd.package}/bin/systemctl show -P StatusText tailscaled.service)
          if [[ $status != Connected* ]]; then
            tailscale up --login-server https://${config.prefstore.system.network.domain.headscale} --auth-key "file:${config.prefstore.service.tailscale.authKeyFile}"
            if [[ $(uname -m) != $(tailscale status | grep $(tailscale ip) | ${pkgs.gawk}/bin/awk '{print $2}') ]]; then
              tailscale logout
              tailscale up --login-server https://${config.prefstore.system.network.domain.headscale} --auth-key "file:${config.prefstore.service.tailscale.authKeyFile}"
            fi
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-abnormal";
        };
        path = [ config.services.tailscale.package ];
        after = [ "tailscaled.service" "post-resume.service" ];
        requiredBy = [ "tailscaled.service" "post-resume.service" ];
      };
    };
}
