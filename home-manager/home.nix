# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  userSetting,
  inputs,
  lib,
  pkgs,
  ...
}: let
in {
  # virtualisation.waydroid.enable = true;
  # programs.vscode = {
  #   enable = true;
  #   extensions = with pkgs.vscode-extensions; [
  #     ms-python.python
  #     ms-python.vscode-pylance
  #     # dracula-theme.theme-dracula
  #     # vscodevim.vim
  #     # yzhang.markdown-all-in-one
  #     # rust-lang.rust-analyzer
  #     # llvm-vs-code-extensions.vscode-clangd
  #   ];
  # };
  home.enableNixpkgsReleaseCheck = false;

  # services.dunst = lib.mkIf (userSetting.windowmanager == "hyprland" || userSetting.windowmanager == "sway") {
  #   enable = true;
  # };

  programs.rofi = lib.mkIf (userSetting.windowmanager == "hyprland" || userSetting.windowmanager == "sway") {
    package = pkgs.rofi-wayland;
    enable = true;
    font = "Bookerly 16";
    # use base16-horizon-dark a
    theme = ./interstellar.rasi;
  };

  # stylix.targets.hyprlock.enable = false;
  # stylix.targets.helix.enable = false;
  # stylix.targets.dunst.enable = true;
  # stylix.targets.rofi.enable = false;
  # stylix.targets.fish.enable = false;
  # stylix.targets.emacs.enable = false;
  # stylix.targets.alacritty.enable = false;
  # stylix.targets.foot.enable = true;
  # stylix.targets.hyprland.enable = false;

  home.file.".local/share/fonts".source = ./fonts;
  home.file.".config/sway/white.jpg".source = ./white.jpg;
  # home.file.".config/sway/config".source = ./swayConfig;
  home.packages = with pkgs; [
    adwaita-qt
    # yt-dlp
    # discord
    fd

    curl
    sqlite

    # for emacs sqlite
    # org mode dot
    # graphviz
    # imagemagick

    # mpvi required
    # tesseract5
    # ffmpeg_5
    # ffmpegthumbnailer
    # mediainfo
    # email
    # mu4e
    # spell check
    # aspell

    # for emacs rime
    # librime

    # libwebp
    # tdlib
    # pkg-config

    foliate
    # (octaveFull.withPackages (opkgs: with opkgs; [symbolic]))
    # verilator
    # telegram-desktop
    # stm32cubemx
    # logisim-evolution
    # shotcut
    # qq
    # zed-editor
    bambu-studio
    # libsForQt5.kdenlive
    keepassxc
    opencc
    # android-studio
    # yt-dlp-light
    # android-tools
    # (arduino-ide.overrideAttrs {extraPkgs = with pkgs; [python311 python311Packages.pyserial pkgs.libsecret];})
    # arduino-ide
    # hugo
    # calibre
    # gimp
    # gnome.cheese
    # kicad
    # libreoffice

    # cargo
    # rustc
    # rust-analyzer
  ];

  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    # inputs.homeManagerModules.nixvim
    # inputs.nix-colors.homeManagerModules.default
    # inputs.ags.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./default.nix
  ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  # programs.ags = {
  #   enable = false;

  #   # null or path, leave as null if you don't want hm to manage the config
  #   configDir = ./ags;

  #   # additional packages to add to gjs's runtime
  #   extraPackages = with pkgs; [
  #     gtksourceview
  #     webkitgtk
  #     accountsservice
  #   ];
  # };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # (final: prev: {
      #   blender = prev.blender.override {cudaSupport = true;};
      # })

      # Helix bleeding edge
      # (
      #   self: super: {
      #     helix = inputs.helix.packages.${self.system}.default;
      #   }
      # )

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-White";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 16;
    };
  };

  qt = {
    platformTheme.name = "gtk";
    enable = true;
    style.name = "adwaita-highcontrast";

    # detected automatically:
    # adwaita, adwaita-dark, adwaita-highcontrast,
    # adwaita-highcontrastinverse, breeze,
    # bb10bright, bb10dark, cde, cleanlooks,
    # gtk2, motif, plastique

    style.package = pkgs.adwaita-qt6;
  };

  # TODO: Set your username
  home = {
    username = "${userSetting.username}";
    homeDirectory = "/home/${userSetting.username}";
  };

  # xdg.desktopEntries.firefox = {
  #   name = "firefox";
  #   exec = "${pkgs.firefox-beta}/bin/firefox-beta";
  # };

  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "text/html" = "firefox.desktop";
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/about" = "firefox.desktop";
  #     "x-scheme-handler/unknown" = "firefox.desktop";
  #   };
  # };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
