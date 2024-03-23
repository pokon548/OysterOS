{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
       	nur.repos.pokon548.todoist-electron
    ];

    global-persistence.directories = [
      ".config/Todoist"
    ];
  };
}
