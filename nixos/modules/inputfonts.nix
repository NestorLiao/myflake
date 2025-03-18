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

  environment.variables = {
    GTK_IM_MODULE = lib.mkForce "";
  };

  imports = [
    inputs.nur-xddxdd.nixosModules.setupOverlay
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

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

      # nerd-fonts.fira-code
      # nerd-fonts.fira-mono
      # nerd-fonts.noto
      # nerd-fonts.terminess-ttf
      # nerd-fonts.ubuntu
      # nerd-fonts.ubuntu-mono

      corefonts
      fira-code
      fira-code-symbols
      font-awesome
      hanazono
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
      hoyo-glyphs
      kaixinsong-fonts
      plangothic-fonts.allideo
      source-code-pro
      source-han-code-jp
      source-han-mono
      source-han-sans
      source-han-serif
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      terminus_font_ttf
      ubuntu_font_family
      vistafonts
      vistafonts-chs
      vistafonts-cht
      wqy_microhei
      wqy_zenhei
    ];

      # https://keqingrong.cn/blog/2019-10-01-how-to-display-all-chinese-characters-on-the-computer/
      fonts.fontconfig =
        let
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
        in
          {
            defaultFonts = rec {
              emoji = [ "Blobmoji" ];
              serif = [
                "Noto Serif"
                "Source Han Serif SC"
              ] ++ emoji ++ serifFallback;
              sansSerif = [
                "Ubuntu"
                "Source Han Sans SC"
              ] ++ emoji ++ sansFallback;
              monospace = [
                "Ubuntu Mono"
                "Noto Sans Mono CJK SC"
              ] ++ emoji ++ sansFallback;
            };
          };

      services.xserver.xkb.layout = "us";

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
