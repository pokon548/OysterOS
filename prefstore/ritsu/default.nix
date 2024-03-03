{ pkgs
, config
, lib
, ...
}:
with lib;
{
  # NOTE: This is a special machine used for microvm. DO NOT use it on real machine.
  config.prefstore = {
    slogan = ''
      The powerless will always be stepped on by the strong!
      You have to lift their boots off you with your own hands!
      You think your 'friends' care about you?
      That's all lies!
      Strength is all that matters!

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
