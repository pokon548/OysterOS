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
        up = "sudo nixos-rebuild switch --flake /persist/etc/nixos --override-input minioyster /persist/etc/private-oyster";
      };
      functions = {
        fish_greeting = "";
      };
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home = {
    packages = with pkgs; [
      fasd
    ];
  };
}
