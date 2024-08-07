{ inputs, lib, ... }:
{
  perSystem =
    { inputs'
    , pkgs
    , system
    , ...
    }:
    let
      pkgsInsecure = import inputs.nixpkgs {
        inherit system;
        config.permittedInsecurePackages = [ "openssl-1.1.1w" ]; # electron-builder still depend on this :(
      };

      pkgsRust = import inputs.fenix {
        inherit system;
      };
    in
    {
      devShells = {
        default = pkgs.mkShell {
          # Enable experimental features without having to specify the argument
          NIX_CONFIG = "experimental-features = nix-command flakes";
          nativeBuildInputs = with pkgs; [ nix home-manager git ];
        };

        postmarket = (pkgs.buildFHSUserEnv
          {
            name = "postmarket-env";
            targetPkgs = pkgs: (with pkgs;
              [
                pmbootstrap
              ]
            );
          }).env;

        wechat-help =
          (pkgsInsecure.buildFHSUserEnv
            {
              name = "wechat-env";
              targetPkgs = pkgsInsecure: (with pkgsInsecure; with xorg;
                [
                  stdenv.cc.cc
                  stdenv.cc.libc
                  pango
                  zlib
                  xcbutilwm
                  xcbutilimage
                  xcbutilkeysyms
                  xcbutilrenderutil
                  libX11
                  libXt
                  libXext
                  libSM
                  libICE
                  libxcb
                  libxkbcommon
                  libxshmfence
                  libXi
                  libXft
                  libXcursor
                  libXfixes
                  libXScrnSaver
                  libXcomposite
                  libXdamage
                  libXdmcp
                  libXtst
                  libXau
                  libXrandr
                  libnotify
                  atk
                  atkmm
                  cairo
                  at-spi2-atk
                  at-spi2-core
                  alsa-lib
                  dbus
                  cups
                  gtk3
                  gdk-pixbuf
                  libexif
                  ffmpeg
                  libva
                  freetype
                  fontconfig
                  libXrender
                  libuuid
                  expat
                  glib
                  nss
                  nspr
                  libGL
                  harfbuzz
                  libxml2
                  pango
                  libdrm
                  mesa
                  vulkan-loader
                  systemd
                  wayland
                  pulseaudio
                  qt6.qt5compat
                  openssl_1_1
                  bzip2
                  libcap
                  brotli
                  graphite2
                  libpng
                  pcre2
                  libz
                  gcc
                ]
              );
            });

        # For developing electron apps
        # Wine is included only for cross-compiling Windows binary. Feel free to remove them if you don't need :)
        electron = (pkgsInsecure.buildFHSUserEnv
          {
            name = "electron-env";
            targetPkgs = pkgsInsecure: (with pkgsInsecure;
              [
                nodejs
                python3
                libcxx
                systemd
                libpulseaudio
                libdrm
                mesa
                stdenv.cc.cc
                atk
                at-spi2-atk
                at-spi2-core
                cairo
                cups
                dbus
                expat
                fontconfig
                freetype
                gdk-pixbuf
                (lib.getLib glibc)
                gtk3
                libnotify
                libuuid
                nspr
                nss
                pango
                systemd
                libappindicator-gtk3
                libdbusmenu
                libxkbcommon
                zlib
                nodePackages.pnpm
                cairo
                pango
                libjpeg
                libpng
                giflib
                librsvg
                pixman
                pkg-config
                gcc_debug
                glibc
                binutils
                stdenv.cc.cc.lib
                clang
                llvmPackages.bintools
                rustup
                rust-analyzer
                yarn

                # For building window variant
                wine
                wine64

                # For building flatpak
                flatpak
                flatpak-builder

                # For building deb
                nss
                gnome2.GConf
                libnotify
                libappindicator
                xorg.libXtst
                libxcrypt
                libxcrypt-legacy

                # For building rpm
                rpm

                # For cross-compiling arm64 binary
                zig
                zstd
                pkg-config
                (lib.getLib glibc)

              ]
            ) ++ (with pkgs.xorg;
              [
                libXScrnSaver
                libXrender
                libXcursor
                libXdamage
                libXext
                libXfixes
                libXi
                libXrandr
                libX11
                libXcomposite
                libxshmfence
                libXtst
                libxcb
              ]
            ) ++ (with pkgs.pkgsCross; [
              mingwW64.buildPackages.gcc
              gnu64.buildPackages.gcc
            ]); # Cross-compiling windows binary on Linux. Feel free to remove them if you don't need :)
          }).env;

        learning = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            clang
            stdenv.cc.cc.lib
          ];

          LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib64:$LD_LIBRARY_PATH";
        };

        rust = pkgs.mkShell {
          nativeBuildInputs = (with pkgsRust; [
            (pkgsRust.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
            ])
          ]) ++ (with pkgs; [
            pkg-config
            openssl
            sqlite
          ]);

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (with pkgs; [
            pkg-config
            openssl
            sqlite
          ])}:$LD_LIBRARY_PATH";
        };

        terraform =
          let
            hcloud_api_token = "`${pkgs.sops}/bin/sops -d --extract '[\"hello\"]' trustzone/terraform/default.yaml`";

            tofu = pkgs.writers.writeBashBin "terraform" ''
              export TF_VAR_hcloud_api_token=${hcloud_api_token}
              ${pkgs.opentofu}/bin/tofu "$@"
            '';
          in
          pkgs.mkShell {
            buildInputs = [ pkgs.terranix pkgs.sops tofu ];
          };

        gtk4-rust = pkgs.mkShell {
          buildInputs = with pkgs; [
            gtk4
            libadwaita
            cairo
            glib
            pkg-config
            librsvg

            cargo
            rustc
          ];

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (with pkgs; [
            pkg-config
            libadwaita
            glib
            gtk4
          ])}:$LD_LIBRARY_PATH";
        };

        openwrt = inputs.nix-environments.devShells."x86_64-linux".openwrt;
      };
    };
}
