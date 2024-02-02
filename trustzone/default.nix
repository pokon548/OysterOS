{ lib
, name
, ...
}:
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./. + "/${name}/default.yaml";
  };
}
