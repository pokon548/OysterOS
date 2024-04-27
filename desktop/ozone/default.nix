{ lib
, pkgs
, config
, ...
}: {
  config = lib.mkIf config.prefstore.desktop.ozone
    {
      environment = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
