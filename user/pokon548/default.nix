{ lib
, pkgs
, config
, ...
}: {
  config = lib.mkIf config.prefstore.user.pokon548.enable
    {
      sops.secrets."pokon548-password".neededForUsers = true;

      users.users.pokon548 = {
        shell = "${pkgs.fish}/bin/fish";
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."pokon548-password".path;
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
        user = "pokon548";
      };

      home-manager.users.pokon548 = { lib, ... }: {
        home = {
          packages = builtins.concatLists
            (with config.prefstore.user.pokon548.application; [
              base
              gnome-extra
              office
              internet
              knowledge
              development
              game
            ]) ++ config.prefstore.user.pokon548.gnome.extension;
          enableNixpkgsReleaseCheck = !config.prefstore.user.pokon548.home.noReleaseCheck;

          stateVersion = "23.11";
        };

        dconf.settings = config.prefstore.user.pokon548.gnome.dconf;
      };
    };
}
