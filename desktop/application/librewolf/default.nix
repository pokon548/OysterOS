{ config, pkgs, lib, ... }:
let
  pkg = pkgs.librewolf-unwrapped;
  extraPrefs = ''
    lockPref('media.peerconnection.enabled', false);
    lockPref("privacy.resistFingerprinting", false);

    lockPref("privacy.clearOnShutdown.cache", false);
    lockPref("privacy.clearOnShutdown.cookies", false);
    lockPref("privacy.clearOnShutdown.history", false);
    lockPref("privacy.clearOnShutdown.downloads", false);

    lockPref("svg.context-properties.content.enabled", true);

    lockPref("permissions.default.geo", 2);

    lockPref("identity.fxaccounts.enabled", true);

    lockPref("browser.compactmode.show", true);
    lockPref("browser.tabs.tabmanager.enabled", false);

    lockPref("xpinstall.enabled", false);
    lockPref("xpinstall.whitelist.required", true);
  '';
  extraPolicies = {
    AppAutoUpdate = false;
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
      "CanvasBlocker@kkapsner.de" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
      };
      "CookieAutoDelete@kennydo.com" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi";
      };
      "customscrollbars@computerwhiz" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/custom-scrollbars/latest.xpi";
      };
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      };
      "7esoorv3@alefvanoon.anonaddy.me" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
      };
      "offline-qr-code@rugk.github.io" = {
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/offline-qr-code-generator/latest.xpi";
      };
      "languagetool-webextension@languagetool.org" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
      };
      "addon@fastforward.team" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/fastforwardteam/latest.xpi";
      };
      "{ddc62400-f22d-4dd3-8b4a-05837de53c2e}" = {
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/read-aloud/latest.xpi";
      };
      "copyplaintext@eros.man" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/copy-plaintext/latest.xpi";
      };
      "{1018e4d6-728f-4b20-ad56-37578a4de76b}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/flagfox/latest.xpi";
      };
      "{531906d3-e22f-4a6c-a102-8057b88a1a63}" = {
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
      };
      "jid0-gRmSxW9ByuHwGjLhtXJg27YnZRs@jetpack" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/scroll-to-top/latest.xpi";
      };
      "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/search-by-image/latest.xpi";
      };
      "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/old-reddit-redirect/latest.xpi";
      };
      "{3c078156-979c-498b-8990-85f7987dd929}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
      };
      "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
      };
      "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/terms-of-service-didnt-read/addon-latest.xpi";
      };
      "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
      };
      "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/absolute-enable-right-click/latest.xpi";
      };
      "{55f61747-c3d3-4425-97f9-dfc19a0be23c}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/spoof-timezone/latest.xpi";
      };
      "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/file/4209984/refined_github-latest.xpi";
      };
      "{74145f27-f039-47ce-a470-a662b129930a}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
      };
      "extension@tabliss.io" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi";
      };
      "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
      };
      "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = {
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/view-page-archive/latest.xpi";
      };
      "{4853d046-c5a3-436b-bc36-220fd935ee1d}" = {
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/undoclosetabbutton/latest.xpi";
      };
      "addon@darkreader.org" = {
        installation_mode = "force_installed";
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      };
    };
  };

  # By default, extraPolicies & extraPrefs in firefox-wrapper will **override** prebuilts.
  # This is not convenient as prebuilts are also required for librewolf.
  # So I rewrite the logic of extraPolicies & extraPrefs to ship both prebuilts and custom hacks together :)
  recursiveMerges = attrList:
    let
      f = attrPath:
        lib.zipAttrsWith (n: values:
          if lib.tail values == [ ] then
            lib.head values
          else if lib.all lib.isList values then
            lib.unique (lib.concatLists values)
          else if lib.all lib.isAttrs values then
            f (lib.attrPath ++ [ n ]) values
          else
            lib.last values);
    in
    f [ ] attrList;
  shippedPoliciesJSON = builtins.fromJSON
    (builtins.readFile (builtins.concatStringsSep "" pkg.extraPoliciesFiles));
  customPoliciesJSON = { policies = extraPolicies; };
  overallPolicyFile = pkgs.writeText "policy.json" (builtins.toJSON
    (recursiveMerges [ shippedPoliciesJSON customPoliciesJSON ]));

  shippedPrefs =
    builtins.readFile (builtins.concatStringsSep "" pkg.extraPrefsFiles);
  overallPrefsFile = pkgs.writeText "librewolf.cfg"
    (builtins.concatStringsSep "" [ shippedPrefs extraPrefs ]);
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkg {
      inherit (pkg)
        ;
      wmClass = "LibreWolf";
      libName = "librewolf";

      extraPoliciesFiles = [ overallPolicyFile ];
      extraPrefsFiles = [ overallPrefsFile ];
    };
  };

  home.global-persistence.directories = [
    ".librewolf"
  ];

  home.packages = with pkgs; [ speechd ];
}
