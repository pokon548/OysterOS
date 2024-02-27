{ lib
, pkgs
, config
, ...
}:
let
  username = "nixostest";
  testedUsername = "pokon548";
in
{
  config = lib.mkIf config.prefstore.user.${username}.enable
    {
      users.users.${username} = {
        shell = "${pkgs.fish}/bin/fish";
        isNormalUser = true;
        initialPassword = "passw0rd!";
        extraGroups = [
          "wheel"
          "networkmanager"
          "kvm"
          "qemu"
          "libvirt"
          "vboxusers"
          "tss"
          "pipewire"
        ];
      };

      services.xserver.displayManager.autoLogin = {
        enable = true;
        user = "${username}";
      };

      home-manager.users.${username} = { lib, ... }: {
        home = {
          packages = builtins.concatLists
            (with config.prefstore.home.${testedUsername}.application; [
              base
              gnome-extra
              office
              internet
              knowledge
              development
              game
            ]) ++ config.prefstore.home.${testedUsername}.gnome.extension;
          file = config.prefstore.home.${testedUsername}.file;
          enableNixpkgsReleaseCheck = !config.prefstore.home.${testedUsername}.noReleaseCheck;

          stateVersion = "23.11";
        };

        programs = config.prefstore.home.${testedUsername}.programs;
        dconf.settings = config.prefstore.home.${testedUsername}.gnome.dconf;
      };
    };
}
