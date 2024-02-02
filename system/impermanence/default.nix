{ lib
, config
, ...
}:
{
  config = lib.mkIf config.prefstore.system.impermanence.enable
    {
      environment.persistence."${config.prefstore.system.impermanence.location}" = {
        hideMounts = config.prefstore.system.impermanence.hideMounts;
        directories = config.prefstore.system.impermanence.directories;
        files = config.prefstore.system.impermanence.files;
      };
    };
}
