{
  pkgs,
  lib,
  inputs,
  userSetting,
  ...
}: {
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-rime
      fcitx5-chinese-addons
      fcitx5-nord
    ];
  };

  imports = [
    # inputs.nur-xddxdd.nixosModules.setupOverlay
  ];

  fonts.fontDir.enable = true;

  fonts.packages = with pkgs;
    lib.mkForce [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "Noto"
          "Terminus"
          "Ubuntu"
          "UbuntuMono"
        ];
      })
        noto-fonts-emoji-blob-bin
      # hanazono
      # plangothic-fonts.allideo
    ];

  # https://keqingrong.cn/blog/2019-10-01-how-to-display-all-chinese-characters-on-the-computer/
  fonts.fontconfig = let
    sansFallback = [
      "Plangothic P1"
      "Plangothic P2"
      "HanaMinA"
      "HanaMinB"
    ];
    serifFallback = [
      "HanaMinA"
      "HanaMinB"
      "Plangothic P1"
      "Plangothic P2"
    ];
  in {
    defaultFonts = rec {
      emoji = ["Blobmoji"];
      serif =
        [
          "Bookerly"
          "Source Han Sans SC"
          "Noto Serif"
        ]
        ++ emoji
        ++ serifFallback;
      sansSerif =
        [
          "Bookerly"
          "Source Han Sans SC"
          "Ubuntu"
        ]
        ++ emoji
        ++ sansFallback;
      monospace =
        [
          "Bookerly"
          "Ubuntu Mono"
          "Noto Sans Mono CJK SC"
        ]
        ++ emoji
        ++ sansFallback;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };
}
