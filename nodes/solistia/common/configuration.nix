# This group is used for network servers. Bravos!
{
  lib,
  modules',
  ...
}:
{
  imports = [ modules'.prefstore ];
}
