[English](README.md) | **简体中文**

# OysterOS
快速，稳定，可靠。基于 [NixOS](https://nixos.org)。

![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)
![state](https://img.shields.io/badge/works-on%20my%20machines-FEDFE1)
[![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fpokon548%2FOysterOS%3Fbranch%3Dmain)](https://garnix.io)

## 组织结构
- 扁平化。配置嵌套层级不过三（多数情况下仅为一），下层配置直接由顶层 flake.nix 统一动态引入，方便（个人）维护，结构清晰；
- 去耦合化。除机器硬件相关，所有应用场景依赖的配置均统一存放在 `prefstore` 内。其余配置不依赖于应用场景，高度可复用，易于定制。

## 系统设计
### 安全策略
- 利用 lanzaboote，将 kernel、initramfs 打包为 UKI，并对 UKI 及启动程序进行签名，由 UEFI 启动时强制执行完整性校验，实现完整的安全启动链，保证系统启动过程未经篡改；
- 利用 LUKS，对系统、swap 进行全盘加密处理，明文数据不落盘，维持系统保密性；
- 利用 nixpak，将可执行任意逻辑的程序沙盒化，限制执行权限，缓解网络攻击风险；
- 利用 sops-nix，将机密内容加密存储在配置中，系统运行时仅内存存留明文，维持机密内容保密性；
- 利用 impermanence，限制系统可读写区域，使未经授权的修改无法持久化，保持核心系统完整性；
- 更多安全设计请阅读配置文件。

### 图形界面
- 桌面：GNOME。在原版基础上，主要添加了三重缓存（[gnome-shell](https://aur.archlinux.org/packages/gnome-shell-performance)、[mutter](https://aur.archlinux.org/packages/mutter-performance)）补丁，并关掉了一些对性能要求较高的动画。更多细节请参考配置文件；
- 浏览器：LibreWolf（Firefox 清爽版，主力）、Ungoogled Chromium（备用，观测网站兼容问题）；
- 编辑器 / IDE：VSCodium（VSCode FOSS 版）、Android Studio（开发 Android 程序）；
- 知识库：Obsidian；
- 更多图形界面设计请阅读配置文件。
### 命令行：
- Shell：fish（日用）、bash（兼容）；
- 编辑器：vim（主力）、helix（学习中，vim 后继者）；

## 如何复用本仓库配置
想要利用本仓库搭建属于你的 NixOS 配置？没问题，请随意 fork，仅需注意以下内容：
- 本项目按 MIT 协议授权；
- 你需要修改 sops-nix 相关（否则无法构建通过――你并不能解密我的秘密！）；
- `MiniOyster` 是我用来过 CI 构建并预留引入私有配置的空 input。你也许想要在这里引入自己的配置，参考 [MiniOyster](https://github.com/pokon548/MiniOyster) 以获得更多细节。

## 致谢（& 配置参考）
- [NixOS](https://nixos.org)；
- [linyifeng dotfiles](https://github.com/linyinfeng/dotfiles)：早期学习 NixOS 时经常参考的配置文件。目前的配置主要参考了其 `leaf-tree like` 的配置结构；