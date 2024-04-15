{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      (steam.override {
        extraPkgs = pkgs: [
          openssl_1_1
          dotnet-runtime
          wqy_microhei
        ];
      })
    ];

    global-persistence.directories = [
      ".steam"
      ".local/share/Steam"
    ];
  };
}
