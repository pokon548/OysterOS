{ inputs
, lib
, config
, pkgs
, ...
}: {
  # NOTE: This is a special user reserved for bootstrap image. DO NOT use it on real machine.
  config = lib.mkIf config.prefstore.user.bootstrapper
    {
      users.users.bootstrapper = {
        initialPassword = "passw0rd!";
        isNormalUser = true;
        shell = "${pkgs.fish}/bin/fish";
        extraGroups = [ "networkmanager" "wheel" ];
      };

      services.getty.autologinUser = "ritsu";
    };
}
