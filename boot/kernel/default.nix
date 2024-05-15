{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.boot.latestKernel
    {
      #boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelPackages =
        let
          linux_intel_lts_pkg = { fetchFromGitHub, buildLinux, ... } @ args:

            buildLinux (args // rec {
              version = "6.6.30";
              modDirVersion = version;

              src = fetchFromGitHub {
                owner = "intel";
                repo = "linux-intel-lts";
                # After the first build attempt, look for "hash mismatch" and then 2 lines below at the "got:" line.
                # Use "sha256-....." value here.
                rev = "lts-v${version}-linux-240508T063812Z";
                hash = "sha256-pcEivADw/L+mpYkQkCQj2v+pU2v2gsx2jEo6f3PJ4r8=";
              };
              kernelPatches = [ ];

              extraMeta.branch = "${version}";
            } // (args.argsOverride or { }));
          linux_intel_lts = pkgs.callPackage linux_intel_lts_pkg { };
        in
        pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_intel_lts);
    };
}
