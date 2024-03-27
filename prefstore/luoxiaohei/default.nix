{ pkgs
, config
, lib
, application
, ...
}:
with lib;
{
  config.prefstore = {
    slogan = ''
      你就不能把话说得更明白些吗？

      Run 'nixos-helo' for the NixOS manual

    '';

    system = {
      i18n = true;
      sudo.noPassword = true;
      sysrq = true;
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
      };
      application = {
        base = with application; [
          vim
          sudo
          git
          gtk

          fish
        ];
      };
    };

    user = {
      pokon548 = {
        enable = true;
      };
    };
  };
}
