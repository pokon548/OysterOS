{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      virt-manager
    ];

    global-persistence.directories = [
      ".config/libvirt"
    ];
  };
}
