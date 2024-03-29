{ pkgs
, config
, lib
, application
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
      systemd = {
        enable = true;
      };
    };

    desktop = {
      font = true;
      im = true;
    };

    system = {
      network.useNetworkManager = false;
      i18n = true;
      sudo.noPassword = true;
    };

    home.ritsu = {
      noReleaseCheck = true;
      application = {
        internet = with application; [
          vim
          sudo
        ];
      };
    };

    user = {
      ritsu = true;
    };
  };
}
