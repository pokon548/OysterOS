{ lib
, name
, config
, ...
}:
{
  networking = {
    networkmanager.enable = config.prefstore.system.network.useNetworkManager;
    useNetworkd = !config.prefstore.system.network.useNetworkManager;
    hostName = name;
  };
}
