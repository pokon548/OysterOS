{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.system.sudo.noPassword
    {
      security.sudo.wheelNeedsPassword = false;
    };
}
