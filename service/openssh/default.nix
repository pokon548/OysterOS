{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.service.openssh.enable
    {
      services.openssh = {
        enable = true;
        ports = [ config.prefstore.system.network.port.ssh ];
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };
    };
}
