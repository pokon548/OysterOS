{ lib
, config
, ...
}: {
  virtualisation = {
    virtualbox.host = {
      enable = config.prefstore.system.virtualisation.virtualbox;
    };

    libvirtd = {
      enable = config.prefstore.system.virtualisation.libvirtd;
      qemu.swtpm.enable = true;
    };
  };

  environment.global-persistence = lib.mkIf config.prefstore.system.virtualisation.libvirtd {
    directories = [ "/var/lib/libvirt" ];
  };
}
