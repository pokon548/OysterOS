{ lib
, name
, ...
}:
{
  networking.hostName = name;
}
