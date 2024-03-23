{ lib
, pkgs
, config
, ...
}:
let
  username = "pokon548";

  # TODO: recursiveMerge should be moved to individual helper
  recursiveMerge = attrList:
    let
      f = attrPath:
        lib.zipAttrsWith (n: values:
          if lib.tail values == [ ]
          then lib.head values
          else if lib.all lib.isList values
          then lib.unique (lib.concatLists values)
          else if lib.all lib.isAttrs values
          then f (lib.attrPath ++ [ n ]) values
          else lib.last values
        );
    in
    f [ ] attrList;

  programsList = (recursiveMerge (
    lib.concatLists (with config.prefstore.home.${username}.application; [
      base
      gnome-extra
      office
      internet
      security
      knowledge
      development
      game
    ]))).default;
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

      home-manager.users.${username} = { lib, ... }: recursiveMerge [
        {
          home = {
            enableNixpkgsReleaseCheck = !config.prefstore.home.${username}.noReleaseCheck;
            packages = config.prefstore.home.${username}.gnome.extension;
            global-persistence.enable = config.prefstore.home.${username}.persistence.enable;
            stateVersion = "23.11";
          };

          dconf.settings = config.prefstore.home.${username}.gnome.dconf;
        }
        programsList
      ];
    };
}
