# "You'll never lose if you never try, son. But you'll never win, either." —Papp
#
# This node is basically the as partitio but without disk encryption.
# It is used in VM for testing breaking changes on partitio node.

{
  pkgs,
  inputs',
  config,
  lib,
  ...
}:
{
  imports = [
    ../partitio/configuration.nix
  ];

  networking.hostName = lib.mkForce "papp";
}
