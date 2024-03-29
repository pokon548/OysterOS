{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.service.postgresql.enable
    {
      services.postgresql.enable = true;
    };
}
