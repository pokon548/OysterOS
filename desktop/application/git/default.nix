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

      # TODO: Embedding sign key into sops
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/signing/id_ed25519.pub";
    };
  };

  home.packages = with pkgs; [ github-cli ];

  home.global-persistence = {
    directories = [
      ".config/gh" # github-cli

      ".ssh/signing"
    ];
  };
}
