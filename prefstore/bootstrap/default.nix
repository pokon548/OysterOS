{ pkgs
, config
, lib
, application
, ...
}:
with lib;
{
  config = {
    prefstore = {
      slogan = ''
        bootstrapper!

        Run 'nixos-helo' for the NixOS manual

      '';

      boot = {
        grub = {
          enable = true;
        };
        latestKernel = true;
      };

      system = {
        sudo.noPassword = true;
        sysrq = true;
      };

      home.ritsu = {
        application = {
          base = with application; [
            vim
            sudo
            git

            fish
          ];
        };
      };

      service = {
        openssh.enable = true;
      };

      user = {
        pokon548 = {
          enable = false;
        };
        ritsu = true;
      };
    };
  };
}
