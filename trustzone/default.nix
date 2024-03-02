{ lib
, name
, ...
}:
{
  sops = {
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./. + "/${name}/default.yaml";
  };
}
