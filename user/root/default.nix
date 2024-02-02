{ inputs
, lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.user.root
    {
      users.users.root = {
        hashedPassword = "!";
        shell = "${pkgs.bash}/bin/bash";
        extraGroups = [ "networkmanager" ];
      };
    };
}
