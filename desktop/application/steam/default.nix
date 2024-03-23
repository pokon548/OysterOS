{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (steam.override {
        extraPkgs = pkgs: [ openssl_1_1 ];
      })
    ];

    global-persistence.directories = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}
