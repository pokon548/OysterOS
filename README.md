# OysterOS Next (WIP)
Fast, safe, and stable NixOS distribution, but totally rewritten for better quality and long-term maintainability.

Currently, it is still WIP and will gradually become feature parity with the [legacy branch](https://github.com/pokon548/OysterOS/tree/legacy)!

## Structure
Most basic things are basically kanged from [nixverse](https://github.com/hgl/nixverse), so you should feel familiar if you already know about that! I will list the actual implementations below to help you better understand the design of OysterOS.

- Unified build-time flags: By gating globally reused but with little difference configs into flags (using [mkOption](https://noogle.dev/f/lib/mkOption/)!), OysterOS keeps copy-pasta codes away and improves the long-term maintainability of the whole repo. It is called `prefstore` and implemented in [here](modules/nixos/prefstore.nix).
- Reusable by design: Most configs are highly optimized for reusability, so the Nix files themselves are basically the document. Feel free to borrow code snippets into your own config (for FREE! This repo is licensed under MIT).
- Preview everything in VM: All systems are adapted to be running in VM, so you can preview your changes without fearing if it works or not! Just run `nix run .#nixosConfigurations.<hostname>.config.system.build.vmWithDisko` and see for yourself!

## Nodes
Most of the nodes are self-explanatory, with the few exceptions that are intended to be shared across different groups of nodes.

By the way, most of nodes' names were coming from [Octopath Traveler](https://www.wikipedia.org/wiki/Octopath_Traveler) because I really love this RPG so much[^1] :).

### [Creator](nodes/creator)
Special group that contains the logic will be reused in every other type of node. Period.

### [Orsterra](nodes/orsterra)
General group for all nodes that are primarily used for servers.

### [Solistia](nodes/solistia)
General group for all nodes that are primarily used for workstations.

[^1]: I am not affiliated with SQUARE ENIX CO., LTD. All product names used herein are trademarks of their respective owners and are used for informational purposes only.