{ pkgs
, config
, ...
}:
{
  # TODO: We should put this in better location (like user service?)
  systemd.user.services.setup-monitor-automatically = {
    Unit = {
      Description = "Automatically setup monitors";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      TimeoutStartSec = 0;
      ExecStart = "${pkgs.writeShellScript "watch-store" ''
        #!/run/current-system/sw/bin/bash
        ${pkgs.gnome-randr}/bin/gnome-randr modify eDP-1 --primary
        ${pkgs.colord}/bin/colormgr device-add-profile xrandr-eDP-1 $(${pkgs.colord}/bin/colormgr get-profiles | grep "Profile ID" | awk ' { print $3 }')
      ''}";
    };
  };
}
