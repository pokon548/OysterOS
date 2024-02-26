{ lib
, pkgs
, config
, ...
}:
let
  username = "pokon548";
in
{
  config = lib.mkIf config.prefstore.user.${username}.enable
    {
      sops.secrets."${username}-password".neededForUsers = true;

      users.users.${username} = {
        shell = "${pkgs.fish}/bin/fish";
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."${username}-password".path;
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
            (with config.prefstore.home.${username}.application; [
              base
              gnome-extra
              office
              internet
              knowledge
              development
              game
            ]) ++ config.prefstore.home.${username}.gnome.extension;
          enableNixpkgsReleaseCheck = !config.prefstore.home.${username}.noReleaseCheck;

          stateVersion = "23.11";
        };

        dconf.settings = config.prefstore.home.${username}.gnome.dconf;
      };
    };
}
