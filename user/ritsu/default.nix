{ inputs
, lib
, config
, pkgs
, ...
}: {
  # NOTE: This is a special user reserved for crosvm isolation. DO NOT use it on real machine.
  config = lib.mkIf config.prefstore.user.ritsu
    {
      users.users.ritsu = {
        password = "";
        isNormalUser = true;
        shell = "${pkgs.bash}/bin/bash";
        extraGroups = [ "networkmanager" ];
      };
    };
}
