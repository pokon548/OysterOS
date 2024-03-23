{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      nur.repos.pokon548.sticky
    ];

    global-persistence.directories = [
      ".local/share/com.vixalien.sticky"
    ];
  };
}
