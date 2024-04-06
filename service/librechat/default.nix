{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.prefstore.service.librechat.enable {
    virtualisation.oci-containers.containers = {
      librechat = {
        image = "ghcr.io/danny-avila/librechat:v0.7.0";
        environment = {
          HOST = "0.0.0.0";
          MONGO_URI = "mongodb://host.containers.internal:27017/LibreChat";
          ENDPOINTS = "openAI,google,bingAI,gptPlugins";
        };
        environmentFiles = [
          "/run/agenix/librechat-env-file"
        ];
        ports = [
          "3000:3080"
        ];
      };
    };
  };
}
