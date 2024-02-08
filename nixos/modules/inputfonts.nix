{pkgs, ...}: {
  # services.xremap = {
  #   userName = "randy";
  #   serviceMode = "user";
  #   withWlroots = true;
  #   # withHypr = true;
  #   yamlConfig = ''
  #     modmap:
  #       - name: Except Chrome
  #         application:
  #           only:zathura
  #         remap:
  #           Space: Pagedown
  #           Tab: Pageup
  #   '';
  #   # alone: BTN_RIGHT
  #   # held: BTN_MIDDLE
  #   # alone_timeout_millis: 1000 # Optional
  # };

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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      nerdfonts
      twemoji-color-font
      fira-code
      fira-code-symbols
      source-han-sans
      hack-font
      jetbrains-mono
    ];
  };

  fonts.fontconfig = {
    defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = ["Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono"];
      sansSerif = ["Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans"];
      serif = ["Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif"];
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
  nixpkgs.overlays = [(self: super: {fcitx-engines = self.fcitx5;})];

  services.xserver.xkb.layout = "us";
}
