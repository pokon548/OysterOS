{ lib
, name
, ...
}:
{
  networking = {
    networkmanager.enable = true;
    hostName = name;
  };
}
