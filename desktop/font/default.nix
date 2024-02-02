{ lib
, config
, pkgs
, ...
}: {
  config = lib.mkIf config.prefstore.desktop.font
    {
      fonts = {
        packages = with pkgs; [
          roboto
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif

          dejavu_fonts
          source-han-sans
          source-han-serif
          source-han-mono

          fira-code-nerdfont

          nur.repos.rewine.ttf-wps-fonts
          nur.repos.rewine.ttf-ms-win10
          nur.repos.pokon548.ttf-blobmoji
        ];
        fontconfig = {
          # Shamelessly kanged from Arch Wiki :)
          enable = true;
          localConf = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
            <fontconfig>
              <its:rules xmlns:its="http://www.w3.org/2005/11/its" version="1.0">
                <its:translateRule
                  translate="no"
                  selector="/fontconfig/*[not(self::description)]"
                />
              </its:rules>

              <description>Android Font Config</description>

              <!-- 关闭内嵌点阵字体 -->
              <match target="font">
                <edit name="embeddedbitmap" mode="assign">
                  <bool>false</bool>
                </edit>
              </match>

              <!-- Add generic family. -->
              <match target="pattern">
                <test qual="any" name="family"><string>emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <!-- This adds Blobmoji as a final fallback font for the default font families. -->
              <match target="pattern">
                <test name="family"><string>sans</string></test>
                <edit name="family" mode="append"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test name="family"><string>serif</string></test>
                <edit name="family" mode="append"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test name="family"><string>sans-serif</string></test>
                <edit name="family" mode="append"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test name="family"><string>monospace</string></test>
                <edit name="family" mode="append"><string>Blobmoji</string></edit>
              </match>


              <!-- Use Blobmoji when other popular fonts are being specifically requested. -->
              <match target="pattern">
                <test qual="any" name="family"><string>Apple Color Emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Segoe UI Emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Segoe UI Symbol</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Android Emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Twitter Color Emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Twemoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Twemoji Mozilla</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>TwemojiMozilla</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>EmojiTwo</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Emoji Two</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>EmojiSymbols</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <match target="pattern">
                <test qual="any" name="family"><string>Symbola</string></test>
                <edit name="family" mode="assign" binding="same"><string>Blobmoji</string></edit>
              </match>

              <!-- 英文默认字体使用 Roboto 和 Noto Serif ,终端使用 DejaVu Sans Mono. -->
              <match>
                <test qual="any" name="family">
                  <string>serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                  <string>Noto Serif</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>sans-serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                  <string>Roboto</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>monospace</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                  <string>DejaVu Sans Mono</string>
                </edit>
              </match>

              <!-- 中文默认字体使用思源黑体和思源宋体,不使用　Noto Sans CJK SC 是因为这个字体会在特定情况下显示片假字. -->
              <match>
                <test name="lang" compare="contains">
                  <string>zh</string>
                </test>
                <test name="family">
                  <string>serif</string>
                </test>
                <edit name="family" mode="prepend">
                  <string>Source Han Serif CN</string>
                </edit>
              </match>
              <match>
                <test name="lang" compare="contains">
                  <string>zh</string>
                </test>
                <test name="family">
                  <string>sans-serif</string>
                </test>
                <edit name="family" mode="prepend">
                  <string>Source Han Sans CN</string>
                </edit>
              </match>
              <match>
                <test name="lang" compare="contains">
                  <string>zh</string>
                </test>
                <test name="family">
                  <string>monospace</string>
                </test>
                <edit name="family" mode="prepend">
                  <string>Noto Sans Mono CJK SC</string>
                </edit>
              </match>

              <!-- Windows & Linux Chinese fonts. -->
              <!-- 把所有常见的中文字体映射到思源黑体和思源宋体，这样当这些字体未安装时会使用思源黑体和思源宋体.
            解决特定程序指定使用某字体，并且在字体不存在情况下不会使用fallback字体导致中文显示不正常的情况. -->
              <match target="pattern">
                <test qual="any" name="family">
                  <string>WenQuanYi Zen Hei</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Sans CN</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>WenQuanYi Micro Hei</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Sans CN</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>WenQuanYi Micro Hei Light</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Sans CN</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>Microsoft YaHei</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Sans CN</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>SimHei</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Sans CN</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>SimSun</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Serif CN</string>
                </edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family">
                  <string>SimSun-18030</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                  <string>Source Han Serif CN</string>
                </edit>
              </match>

              <alias>
                <family>sans-serif</family>
                <prefer>
                  <family>Source Han Sans SC</family>
                  <family>Source Han Sans TC</family>
                  <family>Source Han Sans HW</family>
                  <family>Source Han Sans K</family>
                </prefer>
              </alias>
              <alias>
                <family>monospace</family>
                <prefer>
                  <family>Source Han Sans SC</family>
                  <family>Source Han Sans TC</family>
                  <family>Source Han Sans HW</family>
                  <family>Source Han Sans K</family>
                </prefer>
              </alias>

              <config>
                <!-- Rescan configuration every 30 seconds when FcFontSetList is called -->
                <rescan>
                  <int>30</int>
                </rescan>
              </config>
            </fontconfig>
          '';
        };
      };
    };
}
