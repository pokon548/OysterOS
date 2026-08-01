# This group is used for network servers. Bravos!
{
  lib,
  modules',
  pkgs,
  ...
}:
{
  imports = [
    modules'.prefstore
  ];

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";

    "vm.swappiness" = 3;

    # Workaround: Too much dirty memories may cause system laggy after long uptime.
    #             See https://github.com/pop-os/default-settings/blob/master_noble/etc/sysctl.d/10-pop-default-settings.conf
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 134217728;
    "vm.max_map_count" = 2147483642;
    "fs.inotify.max_user_instances" = 8192;

    # Workaround: bigger file limits
    "fs.file-max" = 100000000000000000;
  };

  virtualisation = {
    vmVariant = {
      prefstore.runningInVM = true;
      virtualisation = {
        memorySize = 8192;
        cores = 8;
      };
    };
  };

  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
    extraArgs = [
      "-b"
    ];
  };

  users = {
    users = {
      pokon548 = {
        description = "Bu Kun";
        isNormalUser = true;
        home = "/home/pokon548";
        group = "pokon548";
        extraGroups = [ "wheel" ];
      };
    };

    groups.pokon548 = { };
  };
}
