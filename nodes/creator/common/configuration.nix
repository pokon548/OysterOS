{
  config,
  inputs',
  modules',
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

  imports = [
    inputs'.preservation.modules.preservation
    inputs'.nur.modules
    modules'.global-persistence
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

    kernel.sysctl = (
      if config.prefstore.boot.allowSysrq then
        {
          "kernel.sysrq" = 1;
        }
      else
        { }
    );
  };

  environment = {
    etc.issue = {
      text = config.prefstore.slogan;
    };

    global-persistence = {
      enable = config.prefstore.impermanence.enable;
      root = "${config.prefstore.impermanence.location}";
      directories = config.prefstore.impermanence.directories;
      files = config.prefstore.impermanence.files;
    };
  };

  i18n = {
    defaultLocale = config.prefstore.region.locale;
    extraLocales = [
      "en_US.UTF-8/UTF-8" # en_US should always available no matter what
    ];
  };
  time.timeZone = config.prefstore.region.timeZone;

  networking = {
    networkmanager = {
      enable = config.prefstore.network.useNetworkManager;
      wifi.powersave = false;
    };
    nftables.enable = true;
    useNetworkd = !config.prefstore.network.useNetworkManager;
  };

  services.timesyncd.servers = (
    if config.prefstore.enableChinaFeatures then
      [
        "ntp1.ntsc.ac.cn"
        "ntp2.ntsc.ac.cn"
        "ntp3.ntsc.ac.cn"
        "ntp1.aliyun.com"
        "ntp2.aliyun.com"
        "ntp3.aliyun.com"
      ]
    else
      [
        "0.pool.ntp.org"
        "1.pool.ntp.org"
        "2.pool.ntp.org"
      ]
  );

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "pokon548"
      ];
      substituters = builtins.concatLists [
        (
          if config.prefstore.enableChinaFeatures then
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

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs'.nur.overlays.default ];
  };

  security = {
    sudo.wheelNeedsPassword = config.prefstore.sudoWithoutPassword;
    tpm2 = (
      if config.prefstore.boot.secureboot then
        {
          enable = true;
          abrmd.enable = true;
        }
      else
        { }
    );
  };

  environment.systemPackages =
    with pkgs;
    (if config.prefstore.boot.secureboot then [ tpm2-tools ] else [ ]);

  system.stateVersion = "26.05";
}
