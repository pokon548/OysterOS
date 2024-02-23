{ lib
, pkgs
, config
, ...
}: {
  config = lib.mkIf config.prefstore.user.nixostest.enable
    {
      users.users.nixostest = {
        shell = "${pkgs.fish}/bin/fish";
        isNormalUser = true;
        initialPassword = "test";
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
        user = "nixostest";
      };

      home-manager.users.nixostest = { lib, ... }: {
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
