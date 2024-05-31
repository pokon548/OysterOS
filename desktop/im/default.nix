{ lib
, pkgs
, config
, ...
}: {
  config = lib.mkIf config.prefstore.desktop.im
    {
      # Workaround for fcitx5 issue under wayland. See: https://github.com/NixOS/nixpkgs/issues/129442
      environment = {
        sessionVariables = {
          NIX_PROFILES =
            "${lib.concatStringsSep " " (lib.reverseList config.environment.profiles)}";
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
          XMODIFIERS = "@im=fcitx";
        };
      };

      i18n.inputMethod = {
        enabled = "fcitx5";

        fcitx5 = {
          addons = with pkgs; [ fcitx5-chinese-addons fcitx5-gtk libsForQt5.fcitx5-qt ];
          ignoreUserConfig = true;
          settings = {
            globalOptions = {
              Hotkey = {
                EnumerateSkipFirst = "False";
              };
              "Hotkey/TriggerKeys" = {
                "0" = "Control+space";
                "1" = "Shift_L";
              };
              Behavior = {
                ShareInputState = "Program";
              };
            };
            inputMethod = {
              "Groups/0" = {
                Name = "默认";
                "Default Layout" = "us";
                DefaultIM = "pinyin";
              };

              "Groups/0/Items/0" = {
                Name = "keyboard-us";
              };

              "Groups/0/Items/1" = {
                Name = "pinyin";
              };

              GroupOrder = {
                "0" = "默认";
              };
            };
            addons = {
              classicui.globalSection = {
                "Vertical Candidate List" = "True";
                UseDarkTheme = "True";
                EnableFractionalScale = "True";
              };
              pinyin.globalSection = {
                EmojiEnabled = "True";
                CloudPinyinEnabled = "False";
                CloudPinyinIndex = 2;
                QuickPhraseKey = "";
                VAsQuickphrase = "False";
              };
            };
          };
        };
      };
    };
}
