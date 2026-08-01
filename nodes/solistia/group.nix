{
  common =
    { lib, ... }:
    {
      system = lib.mkDefault "x86_64-linux";
      channel = lib.mkDefault "lts";
    };

  ludo = { };
}
