{ lib
, config
, ...
}:
{
  config = lib.mkIf config.prefstore.system.impermanence.enable
    {
      environment.global-persistence = {
        enable = true;
        root = "${config.prefstore.system.impermanence.location}";
        directories = config.prefstore.system.impermanence.directories;
        files = config.prefstore.system.impermanence.files;
      };
    };
}
