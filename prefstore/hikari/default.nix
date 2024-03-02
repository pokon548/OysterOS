{ pkgs
, config
, lib
, ...
}:
with lib;
{
  config.prefstore = {
    slogan = ''
      I haven't, Ritsu. Ku was built on warfare, with little regard for the people under it. 
      But I want to change that.
      I want Ku to be a home to all, regardless of birth. 
      A place where we look out for each other. 
      In order to realize that, I would suffer any loss.

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
