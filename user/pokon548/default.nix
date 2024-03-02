{ lib
, pkgs
, config
, ...
}:
let
  username = "pokon548";
  packagesList = with config.prefstore.home.${username}.application; [
    base
    gnome-extra
    office
    internet
    knowledge
    development
    game
  ] ++ config.prefstore.home.${username}.gnome.extension;
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
          packages = lib.concatLists packagesList;
          file = config.prefstore.home.${username}.file;
          enableNixpkgsReleaseCheck = !config.prefstore.home.${username}.noReleaseCheck;
          stateVersion = "23.11";
        };

        programs = config.prefstore.home.${username}.programs;
        dconf.settings = config.prefstore.home.${username}.gnome.dconf;
      };

      # NOTE: Not using home-manager module. It doesn't keep all files :(
      # TODO: Make it as a general module
      environment.persistence."${config.prefstore.system.impermanence.location}".users.${username} = lib.mkIf config.prefstore.home.${username}.persistence.enable {
        directories = config.prefstore.home.${username}.persistence.directories ++ lib.concatLists (lib.lists.remove null (lib.forEach
          (builtins.concatLists
            packagesList)
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
          (builtins.concatLists
            packagesList)
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
