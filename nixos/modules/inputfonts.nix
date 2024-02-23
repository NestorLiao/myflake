{
  pkgs,
  lib,
  inputs,
  ...
}: let
  shell = script: lib.strings.splitString " " "${lib.getExe' inputs.hyprland.packages.${pkgs.system}.hyprland "hyprctl"} dispatch exec ${lib.getExe' (pkgs.writeShellScriptBin "script" script) "script"}";
in {
  imports = [
    inputs.nur-xddxdd.nixosModules.setupOverlay
  ];
  services.xremap = {
    userName = "nestor";
    serviceMode = "user";
    withWlroots = true;
    # withHypr = true;
    debug = true;
    mouse = true;
    config = {
      modmap = [
        {
          name = "Name";
          remap = {
            BTN_SIDE = "KEY_PAGEDOWN";
            BTN_EXTRA = "KEY_PAGEUP";
            KEY_KPMINUS = "KEY_PAGEUP";
            KEY_KPPLUS = "KEY_PAGEDOWN";
            KEY_KPENTER = {
              press = {
                launch = shell "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch cyclenext";
              };
              release = {
                launch = shell "${lib.getExe' pkgs.tmux "tmux"} select-pane -l";
              };
            };
          };
          # device = {
          #   only = ["SEMICO Digio2 Ten Key Consumer Control" "SEMICO Digio2 Ten Key" "SEMICO Digio2 Ten Key System Control" "SEMICO Digio2 Ten Key Consumer Control 1"];
          # };
        }
      ];
    };
  };

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

      corefonts
      fira-code
      fira-code-symbols
      font-awesome
      kaixinsong-fonts
      hanazono
      hanyi-wenhei
      hoyo-glyphs
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji-blob-bin
      noto-fonts-extra
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
      serif = ["Noto Serif" "Source Han Serif SC"] ++ emoji ++ serifFallback;
      sansSerif = ["Ubuntu" "Source Han Sans SC"] ++ emoji ++ sansFallback;
      monospace = ["Ubuntu Mono" "Noto Sans Mono CJK SC"] ++ emoji ++ sansFallback;
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
      fcitx5-nord
    ];
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
