# "You'll never lose if you never try, son. But you'll never win, either." —Papp
#
# This node is basically the as partitio but without disk encryption.
# It is used in VM for testing breaking changes on partitio node.
#
# NP: You must running this node with the following env:
#
# QEMU_OPTS="-device virtio-vga-gl -display gtk,gl=on"
#
# Otherwise it will NOT boot into desktop!

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

  prefstore = {
    impermanence.enable = lib.mkForce false; # Looks like VM does not compatible with this
  };

  networking.hostName = lib.mkForce "papp";
}
