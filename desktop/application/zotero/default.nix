{ pkgs
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      zotero_7
    ];

    global-persistence.directories = [
      ".zotero"
    ];
  };
}
