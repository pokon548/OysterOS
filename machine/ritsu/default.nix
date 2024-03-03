{ self
, lib
, config
, inputs
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

    hypervisor = "crosvm";
    socket = "control.socket";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
