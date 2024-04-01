{ pkgs
, config
, lib
, application
, ...
}:
with lib;
{
  config = {
    sops.secrets = {
      "vaultwarden/admin-token" = { };
      "vaultwarden/push-installation-id" = { };
      "vaultwarden/push-installation-key" = { };

      "headscale/private-key-encrypt" = { };
      "headscale/private-key-noise" = { };
    };

    sops.templates."vaultwarden-env".content = ''
      ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin-token"}
      PUSH_INSTALLATION_ID=${config.sops.placeholder."vaultwarden/push-installation-id"}
      PUSH_INSTALLATION_KEY=${config.sops.placeholder."vaultwarden/push-installation-key"}
    '';

    prefstore = {
      slogan = ''
        你就不能把话说得更明白些吗？

        Run 'nixos-helo' for the NixOS manual

      '';

      boot = {
        latestKernel = true;
        systemd = {
          enable = true;
        };
      };

      system = {
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

      service = {
        caddy.enable = true;
        headscale = {
          enable = true;
          private_key_path = config.sops.secrets."headscale/private-key-encrypt".path;
          noise.private_key_path = config.sops.secrets."headscale/private-key-noise".path;
        };
        openssh.enable = true;
        postgresql.enable = true;
        rustdesk-server.enable = true;
        vaultwarden = {
          enable = true;
          environmentFile = config.sops.templates."vaultwarden-env".path;
        };
      };

      user = {
        nixostest.enable = true;
        pokon548 = {
          enable = false;
        };
      };
    };
  };
}
