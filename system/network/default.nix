{ lib
, name
, config
, ...
}:
{
  sops.secrets."dingy.bin" = {
    format = "binary";
    sopsFile = ../../trustzone/common/dingy.bin;
  };

  networking = {
    networkmanager.enable = config.prefstore.system.network.useNetworkManager;
    useNetworkd = !config.prefstore.system.network.useNetworkManager;
    hostName = name;
  };
}
