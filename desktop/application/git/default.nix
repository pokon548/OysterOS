{ pkgs
, config
, ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      pull.ff = "only";
      credential.helper = "libsecret";
      commit.gpgSign = true;

      # fish git status
      bash.showInformativeStatus = true;
    };
  };

  home.packages = with pkgs; [ github-cli ];

  home.global-persistence.directories = [
    ".config/gh" # github-cli
  ];
}
