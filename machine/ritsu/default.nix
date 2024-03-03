{ lib
, pkgs
, ...
}: {
  # NOTE: This is a special machine used for crosvm isolation. DO NOT use it on real machine.
  microvm = {
    volumes = [{
      mountPoint = "/var";
      image = "var.img";
      size = 256;
    }];

    shares = [{
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];

    crosvm.extraArgs = [
      "--gpu=context-types=cross-domain"
      "--wayland-sock $XDG_RUNTIME_DIR/wayland-0"
    ];

    hypervisor = "crosvm";
    socket = "control.socket";
  };

  environment.systemPackages = with pkgs; [
    sommelier
    firefox
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
