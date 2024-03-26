{ pkgs
, lib
, config
, ...
}:
{
  home = {
    packages = with pkgs; [
      # NOTE: Workaround for collision bwtween rustdesk-flutter and localsend. They all introduce flutter.
      #
      # https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/
      (lib.hiPrio rustdesk-flutter)
    ];

    global-persistence.directories = [
      ".config/rustdesk"
    ];
  };
}
