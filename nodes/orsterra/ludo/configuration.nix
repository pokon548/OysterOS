# "Sometimes ya gotta lose to win!" — Ludo
#
# This node is served as arcade cabinet for retro games. Running on one of my old tablet.
# Basically this node is carefully crafted for one of my best friend :)
{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.hostName = "ludo";

  services.xserver = {
    enable = true;
    desktopManager.retroarch = {
      enable = true;
      extraArgs = [
        "--host"
      ];
    };
  };
}
