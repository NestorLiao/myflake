{
  pkgs,
  lib,
  inputs,
  userSetting,
  ...
}: let
  shell = script: lib.strings.splitString " " "${lib.getExe' inputs.hyprland.packages.${pkgs.system}.hyprland "hyprctl"} dispatch exec ${lib.getExe' (pkgs.writeShellScriptBin "script" script) "script"}";
in {
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];

  imports = [
    inputs.nur-xddxdd.nixosModules.setupOverlay
    inputs.xremap-flake.nixosModules.default
    # inputs.nur-xddxdd.nixosModules.qemu-user-static-binfmt
  ];
  services.xremap = {
    userName = userSetting.username;
    serviceMode = "user";
    withWlroots = true;
    debug = true;
    mouse = true;
    # config.modmap = [
    #   {
    #     name = "mouse";
    #     remap = {
    #       "BTN_SIDE" = "KEY_PAGEDOWN";
    #       "BTN_EXTRA" = "KEY_PAGEUP";
    #       # KEY_KPENTER = {
    #       #   press = {
    #       #     launch = shell "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch cyclenext";
    #       #   };
    #       #   release = {
    #       #     launch = shell "${lib.getExe' pkgs.tmux "tmux"} select-pane -l";
    #       #   };
    #       # };
    #     };
    #     # device = {
    #     #   only = ["SEMICO Digio2 Ten Key Consumer Control" "SEMICO Digio2 Ten Key" "SEMICO Digio2 Ten Key System Control" "SEMICO Digio2 Ten Key Consumer Control 1"];
    #     # };
    #   }
    #   {
    #     name = "pcb";
    #     remap = {
    #       "KEY_KP0" = "C_s";
    #       "KEY_KP1" = "C_z";
    #       "KEY_KP2" = "C_y";
    #       "KEY_KP3" = "KEY_DELETE";
    #       "KEY_KP4" = "n";
    #       "KEY_KP5" = "C_g";
    #       "KEY_KP6" = "C_q";
    #       "KEY_KP7" = "p";
    #       "KEY_KP8" = "b";
    #       "KEY_KP9" = "u";
    #       "KEY_KPMINUS" = "KEY_PAGEUP";
    #       "KEY_KPPLUS" = "KEY_PAGEDOWN";
    #       # KEY_KPENTER = {
    #       #   press = {
    #       #     launch = shell "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch cyclenext";
    #       #   };
    #       #   release = {
    #       #     launch = shell "${lib.getExe' pkgs.tmux "tmux"} select-pane -l";
    #       #   };
    #       # };
    #     };
    #     device = {
    #       # only = ["SEMICO Digio2 Ten Key Consumer Control" "SEMICO Digio2 Ten Key" "SEMICO Digio2 Ten Key System Control" "SEMICO Digio2 Ten Key Consumer Control 1"];
    #       not = ["foostan Corne" "foostan Corne Mouse" "foostan Corne System Control" "foostan Corne Consumer Control" "foostan Corne Keyboard"];
    #     };
    #   }
    # ];

    config.modmap = [
      {
        name = "mouse";
        remap = {
          "BTN_SIDE" = "KEY_PAGEDOWN";
          "BTN_EXTRA" = "KEY_PAGEUP";
          "KEY_KPMINUS" = "KEY_PAGEUP";
          "KEY_KPPLUS" = "KEY_PAGEDOWN";
          # KEY_KPENTER = {
          #   press = {
          #     launch = shell "${lib.getExe' pkgs.hyprland "hyprctl"} dispatch cyclenext";
          #   };
          #   release = {
          #     launch = shell "${lib.getExe' pkgs.tmux "tmux"} select-pane -l";
          #   };
          # };
        };
        # device = {
        #   only = ["SEMICO Digio2 Ten Key Consumer Control" "SEMICO Digio2 Ten Key" "SEMICO Digio2 Ten Key System Control" "SEMICO Digio2 Ten Key Consumer Control 1"];
        # };
      }

      # {
      #   name = "ctrl=caps_lock";
      #   device.not = ["foostan Corne" "foostan Corne Mouse" "foostan Corne System Control" "foostan Corne Consumer Control" "foostan Corne Keyboard"];
      #   remap = {
      #     # "CapsLock" = {
      #     #   held = "Ctrl_L";
      #     #   alone = "Esc";
      #     #   aloneTimeout = 500;
      #     # };

      #     # "KEY_KP0" = "C_s";
      #     # "KEY_KP1" = "C_z";
      #     # "KEY_KP2" = "C_y";
      #     # "KEY_KP3" = "KEY_DELETE";
      #     # "KEY_KP4" = "n";
      #     # "KEY_KP5" = "C_g";
      #     # "KEY_KP6" = "C_q";
      #     # "KEY_KP7" = "p";
      #     # "KEY_KP8" = "b";
      #     # "KEY_KP9" = "u";
      #     # "KEY_KPMINUS" = "KEY_PAGEUP";
      #     # "KEY_KPPLUS" = "KEY_PAGEDOWN";

      #   };
      # }
      # {
      #   name = "swap alt_l / meta_l";
      #   device.not = ["ZSA Technology Labs Voyager"];
      #   application.not = [
      #     ".gamescope-wrapped"
      #     "com.moonlight_stream.Moonlight"
      #   ];
      #   remap = {
      #     "KEY_LEFTMETA" = "KEY_LEFTALT";
      #   };
      # }
      # {
      #   name = "swap meta_l / alt_l";
      #   device.not = ["ZSA Technology Labs Voyager"];
      #   application.not = [
      #     ".gamescope-wrapped"
      #     "com.moonlight_stream.Moonlight"
      #   ];
      #   remap = {
      #     "KEY_LEFTALT" = "KEY_LEFTMETA";
      #   };
      # }
    ];
  };

  xdg = {
    mime.defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
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
      # hanyi-wenhei
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
    enable = true;
    type = "fcitx5";
    fcitx5.addons =
      #   # 为了不使用默认的 rime-data，改用我自定义的小鹤音形数据，这里需要 override
      #   # 参考 https://github.com/NixOS/nixpkgs/blob/e4246ae1e7f78b7087dce9c9da10d28d3725025f/pkgs/tools/inputmethods/fcitx5/fcitx5-rime.nix
      #   config.packageOverrides = pkgs: {
      #     fcitx5-rime = pkgs.fcitx5-rime.override {
      #       rimeDataPkgs = [
      #         # 小鹤音形配置，配置来自 flypy.com 官方网盘的鼠须管配置压缩包「小鹤音形“鼠须管”for macOS.zip」
      #         # 我仅修改了 default.yaml 文件，将其中的半角括号改为了直角括号「 与 」。
      #         ./tiger-code
      #       ];
      #     };
      #   };
      with pkgs; [
        rime-data
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
