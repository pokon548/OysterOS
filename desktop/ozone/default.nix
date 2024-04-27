{ lib
, pkgs
, config
, ...
}: {
  config = lib.mkIf config.prefstore.desktop.ozone
    {
      # Workaround for fcitx5 issue under wayland. See: https://github.com/NixOS/nixpkgs/issues/129442
      environment = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
