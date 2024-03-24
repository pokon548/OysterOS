{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.system.tpm
    {
      security.tpm2 = {
        enable = true;
        abrmd.enable = true;
      };

      environment.systemPackages = with pkgs; [ tpm2-tools ];
    };
}
