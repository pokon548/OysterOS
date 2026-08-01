# "I'll be back once I eliminate that devil called poverty from the world!" — Partitio
#
# This node is served as one of my laptop. Creativity and possibility starts here! :)

{
  pkgs,
  inputs',
  config,
  lib,
  ...
}:
{
  imports = [ inputs'.hardware.modules.lenovo-ideapad-14imh9 ];

  prefstore = {
    boot = {
      kernel = "zen";
      loader = "systemd";
    };

    impermanence.enable = true;
  };

  networking.hostName = "partitio";
}
