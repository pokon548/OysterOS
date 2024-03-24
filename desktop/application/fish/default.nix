{ pkgs
, config
, ...
}:
{
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        ll = "ls -l";
        up = "cd /etc/nixos && nix flake update && sudo nixos-rebuild switch";
      };
      functions = {
        fish_greeting = "";
      };
      plugins = [
        {
          name = "sponge";
          src = pkgs.fetchFromGitHub {
            owner = "meaningful-ooo";
            repo = "sponge";
            rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
            hash = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
          };
        }
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "1af8bf782cfea6c9da85716bd45c24adb3499556";
            hash = "sha256-oLD7gYFCIeIzBeAW1j62z5FnzWAp3xSfxxe7kBtTLgA=";
          };
        }
        {
          name = "virtualfish";
          src = pkgs.fetchFromGitHub {
            owner = "justinmayer";
            repo = "virtualfish";
            rev = "3f0de6e9a41d795237beaaa04789c529787906d3";
            hash = "sha256-M4IzmQHELh7A9ZcnNCXSuMk0x71wxeTR35bpDVZDqiw=";
          };
        }
        {
          name = "gitnow";
          src = pkgs.fetchFromGitHub {
            owner = "joseluisq";
            repo = "gitnow";
            rev = "aba9145cd352598b01aa2a41844c55df92bc6b3b";
            hash = "sha256-eImCiEhhbXOkwQqRgpqw481i0Wg4c5nADQlG/O+OH0E=";
          };
        }
      ];
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
