{ lib
, config
, ...
}: {
  config = lib.mkIf config.prefstore.system.i18n
    {
      i18n = {
        defaultLocale = "zh_CN.UTF-8";
      };
    };
}
