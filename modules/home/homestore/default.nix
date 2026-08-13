# Custom home-manager module to define dconf like build-time config for OysterOS!
# Well it is basically prefstore but copy-pasted for home-manager
{
  pkgs,
  lib,
  ...
}:
let
  settingsFormat = pkgs.formats.json { };
in
{
  options.homestore = with lib; {
    niri = {
      outputConfig = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
        default = { };
        description = ''
          Give niri output config to me!
        '';
      };
    };
  };
}
