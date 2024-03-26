{ pkgs
, config
, ...
}:
{
  home = {
    global-persistence.directories = [
      ".config/VirtualBox"
      "VirtualBox VMs"
    ];
  };
}
