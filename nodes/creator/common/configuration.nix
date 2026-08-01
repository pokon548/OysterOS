{
  lib,
  config,
  pkgs,
  ...
}:
{
  warnings = [
    (
      if config.prefstore.runningInVM then
        "You are building this flake for VM. Bootloader will be locked into systemd no matter the config of config.prefstore.boot.loader."
      else
        ""
    )
  ];
  boot = {
    loader = (
      if config.prefstore.boot.loader == "systemd" || config.prefstore.runningInVM then
        {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        }
      else
        {
          grub.enable = true;
        }
    );

    kernelPackages = (
      if config.prefstore.boot.kernel == "latest" then
        pkgs.linuxPackages_latest
      else if config.prefstore.boot.kernel == "zen" then
        pkgs.linuxPackages_zen
      else
        pkgs.linuxPackages
    );
  };

  environment.etc.issue = {
    text = config.prefstore.slogan;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [
        "pokon548"
      ];
      substituters = builtins.concatLists [
        (
          if config.prefstore.nix.useChinaMirror then
            [ "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1" ]
          else
            [ ]
        )
        [
          "https://cache.ctrl-os.com"
          "https://nix-community.cachix.org"
        ]
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ctrl-os:baPzGxj33zp/P+GAIJXsr8ss9Law+qEEFViX1+flbv8="
      ];
    };
  };

  virtualisation.vmVariant = {
    prefstore.runningInVM = true;
    virtualisation = {
      memorySize = 1024;
      cores = 4;
    };
  };

  system.stateVersion = "26.05";
}
