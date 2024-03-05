**English** | [简体中文](README_CN.md)

# OysterOS
Fast, Safe and Stable. Based on [NixOS](https://nixos.org).

![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)
![state](https://img.shields.io/badge/works-on%20my%20machines-FEDFE1)

## Structure
- Flat. Most configs are limited up to three nesting levels (only one in most cases). All low-level configs are automatically imported in `flake.nix`, which brings convinence in (personal) maintainance and clean structure.
- Decentralized. Despite hardware info, all scene-related configs live in `prefstore`. Any other configs are independent from usage, so you may customize and reuse them easily.

## Design
### Security
- lanzaboote: Generated UKI image from kernel and initramfs. This realized the Chain of Trust and ensure boot process remain intact
- luks: Encrypt system and swap partition. Keep everything confidential
- nixpak: Sandbox any apps executing third-party logic to mitigate online threats
- sops-nix: Keep confident info only in memory.
- impermanence: Limit write areas in system, which let unauthorized modifies non-persistable.

### Graphic
- Desktop: GNOME with triple buffer patch ([gnome-shell](https://aur.archlinux.org/packages/gnome-shell-performance), [mutter](https://aur.archlinux.org/packages/mutter-performance)) and reduced animations overhaul my hardware. See configs for more info
- Browser: LibreWolf (Decluttered Firefox. Main browser), Ungoogled Chromium (Backup. Used to verify compability issue)
- Editor / IDE: VSCodium (VSCode FOSS), Android Studio (Used to develop Android apps)
- Knowledge base: Obsidian
- See configs for more designs

### Terminal
- Shell: fish (Daily driver), bash (For backward  compability)
- Editor: vim (Daily driver), helix (Successor of vim. Still learning)

## Reuse this repo
Wanna reuse this repo to buid your NixOS? Great! Before hacking with this repo, here is some hints help you get started quickly:
- This repo is licensed under MIT license
- sops-nix is not world readable. You must modify it (Otherwise you will not pass the build. You cannot decrypt my secrets anyway)
- `MiniOyster` is a stub input for me passing CI builds and including private configs. You may wanna change it to your own input. See [MiniOyster](https://github.com/pokon548/MiniOyster) for details.

## Credit (& Reference)
- [NixOS](https://nixos.org)
- [linyifeng dotfiles](https://github.com/linyinfeng/dotfiles): Main reference repo when I learn to use NixOS. Currently I kanged its `leaf-tree like` structure.