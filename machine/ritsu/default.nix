{ lib
, pkgs
, ...
}: {
  # NOTE: This is a special machine used for crosvm isolation. DO NOT use it on real machine.
  microvm = {
    volumes = [{
      image = "root-overlay.img";
      mountPoint = "/";
      size = 8192;
    }];

    interfaces = [
      {
        type = "tap";
        id = "crosvm_tap";
        mac = "02:00:00:00:00:01";
      }
    ];

    cpu = 4;
    mem = 8192;

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];

    graphics.enable = true;

    hypervisor = "crosvm";
    socket = "control.socket";
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    wget
    librewolf
  ];

  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-1";
    DISPLAY = ":0";
    QT_QPA_PLATFORM = "wayland"; # Qt Applications
    GDK_BACKEND = "wayland"; # GTK Applications
    XDG_SESSION_TYPE = "wayland"; # Electron Applications
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  systemd.user.services.wayland-proxy = {
    enable = true;
    description = "Wayland Proxy";
    serviceConfig = with pkgs; {
      # Environment = "WAYLAND_DISPLAY=wayland-1";
      ExecStart = "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
      Restart = "on-failure";
      RestartSec = 5;
    };
    wantedBy = [ "default.target" ];
  };

  systemd.network = {
    enable = true;
    networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [ "192.168.10.2/24" ];
        Gateway = "192.168.10.1";
        DNS = [ "223.5.5.5" ];
        DHCP = "no";
      };
    };
  };

  hardware.opengl.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
