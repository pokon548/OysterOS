# This group is used for network servers. Bravos!
{
  lib,
  modules',
  ...
}:
{
  imports = [ modules'.prefstore ];

  boot.loader.grub.device = "/dev/vda";
  services.openssh.enable = true;

  virtualisation.vmVariant = {
    prefstore.runningInVM = true;
    virtualisation = {
      memorySize = 1024;
      cores = 2;
    };
  };
}
