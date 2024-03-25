{ lib
, name
, config
, ...
}:
{
  sops = {
    age = {
      sshKeyPaths = [ ];
      keyFile = lib.mkDefault (
        if config.environment.global-persistence.enable then
          "/persist/var/lib/sops-nix/key"
        else
          "/var/lib/sops-nix/key"
      );
    };
    defaultSopsFile = ./. + "/${name}/default.yaml";
  };
}
