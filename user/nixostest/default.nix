{ lib
, pkgs
, config
, ...
}:
let
  username = "nixostest";
  testedUsername = "pokon548";
  packagesList = lib.concatLists [
    (lib.concatLists (with config.prefstore.home.${username}.application; [
      base
      gnome-extra
      office
      internet
      knowledge
      development
      game
    ]))
    config.prefstore.home.${username}.gnome.extension
  ];
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

      environment.persistence."${config.prefstore.system.impermanence.location}".users.${testedUsername} = lib.mkIf config.prefstore.home.${testedUsername}.persistence.enable {
        directories = config.prefstore.home.${username}.persistence.directories ++ lib.concatLists (lib.lists.remove null (lib.forEach
          packagesList
          (x:
            if (lib.hasAttr "pname" x) then
              if (lib.hasAttr "${x.pname}" config.prefstore.appPersist)
              then
                config.prefstore.appPersist.${x.pname}.home.directories
              else
                lib.warn "${x.pname} does not have any impermanence rules! Data expected to be lost." null
            else
              lib.warn "${builtins.toString x} seems to be nixpaked app. This is currently not supported by impermanence." null
          )));

        files = config.prefstore.home.${username}.persistence.files ++ lib.concatLists (lib.lists.remove null (lib.forEach
          packagesList
          (x:
            if (lib.hasAttr "pname" x) then
              if (lib.hasAttr "${x.pname}" config.prefstore.appPersist)
              then
                config.prefstore.appPersist.${x.pname}.home.files
              else
                null
            else
              null
          )));
      };
    };
}
