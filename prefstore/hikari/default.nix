{ pkgs
, config
, lib
, ...
}:
with lib;
{
  config.prefstore = {
    slogan = ''
      The world is a cruel and irrational place.
      
      I wanted something to believe in. Something to hold fast to.
      I want to extend a hand to the weak and cleave the wickedness from this world.
      I wish to be that sword for the people.

      Run 'nixos-helo' for the NixOS manual

    '';

    boot = {
      latestKernel = true;
      secureboot = true;
      systemd = {
        enable = true;
      };
    };

    desktop = {
      font = true;
      im = true;
      gnome.enable = true;
    };

    system = {
      impermanence.enable = true;
      i18n = true;
      sudo.noPassword = true;
    };

    home.pokon548 = {
      noReleaseCheck = true;
      persistence = {
        enable = true;
        directories = [
          "公共"
          "视频"
          "图片"
          "文档"
          "下载"
          "音乐"
          "桌面"
        ];
        files = [
          ".config/monitors.xml"
        ];
      };
      application = {
        base = with pkgs; [
          vim
          sudo
        ];

        internet = with pkgs; [
          librewolf
          ungoogled-chromium
        ] ++ (with config.prefstore.desktop.application; [
          qq
        ]);
      };
    };

    user = {
      pokon548 = {
        enable = true;
      };
    };
  };
}
