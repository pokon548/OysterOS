{ pkgs
, config
, lib
, ...
}:
{
  home = {
    packages = with pkgs; [
      # Unshare network for wpsoffice. Suitable for dealing sensitive documents
      (wpsoffice-cn.overrideAttrs (old: {
        installPhase = builtins.replaceStrings
          [ "--replace /usr/bin $out/bin" ]
          [ "--replace /usr/bin \"${pkgs.util-linux}/bin/unshare -n -r $out/bin\"" ]
          old.installPhase;
      }))
    ];

    global-persistence.directories = [
      ".config/Kingsoft"
      ".config/kingsoft"
    ];
  };
}
