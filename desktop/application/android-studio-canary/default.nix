{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      androidStudioPackages.canary
    ];

    global-persistence.directories = [
      ".android"
      "Android"
      "AndroidStudioProjects"
    ];
  };
}
