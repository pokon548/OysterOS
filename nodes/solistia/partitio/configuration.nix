# "I'll be back once I eliminate that devil called poverty from the world!" — Partitio
#
# This node is served as one of my laptop. Creativity and possibility starts here! :)

{
  inputs',
  modules',
  ...
}:
{
  imports = [ 
    inputs'.hardware.modules.lenovo-ideapad-14imh9

    modules'.font
    modules'.inventor
  ];

  prefstore = {
    boot = {
      kernel = "zen";
      loader = "systemd";
    };

    enableChinaFeatures = true;
    impermanence.enable = true;
  };

  networking.hostName = "partitio";
}
