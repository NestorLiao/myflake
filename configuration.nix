{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  systemd.network.networks.randy.dns = [ 8.8 0.8 0.8 ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.sudo.wheelNeedsPassword = false;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

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

    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.v2raya.enable = true;
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.xwayland.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      fira-code
      source-han-sans
      hack-font
      jetbrains-mono
    ];
  };

  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace =
        [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono" ];
      sansSerif = [ "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans" ];
      serif = [ "Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif" ];
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-nord];
  };
  nixpkgs.overlays = [ (self: super: { fcitx-engines = self.fcitx5; }) ];

  services.xserver.layout = "us";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.randy = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "plugdev" ];
    packages = with pkgs; [ ];
  };

  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  environment.systemPackages = with pkgs; [
    gdb
    libsForQt5.bluedevil
    alsa-utils
    gnumake
    gcc
    cmake
    wl-clipboard-x11
    wget
    clang-tools
    git
    alacritty
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
  nix.settings.trusted-users = [ "randy" ];
  users.defaultUserShell = pkgs.fish;

  programs.fish = {
    enable = true;
    shellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
      thefuck --alias | source 
    '';

    shellAbbrs = {
      "e" = "hx";
      "r" = "fg";
      "diff" = "nvim -d";
      "grep" = "rg";
      "vi" = "nvim";
      "mann" = "tldr";
      "find" = "fd";
      "tree" = "nnn";
      "sed" = "sd";
      "df" = "duf";
      "du" = "gdu";
      "ping" = "gping";
      "mpc" = "vimpc";
      "top" = "gotop";
      "cat" = "bat";
      "sh" = "nix shell nixpkgs#";
      "nixh" = "nix-prefetch-url";
      "nixhu" = "nix-prefetch-url --unpack";
      "sys" = "systemctl";
      "sysu" = "systemctl --user";
      "up" = "nixos-rebuild --flake .# build";
      "upp" = "doas nixos-rebuild --flake .# switch";
      "snr" = "sudo nixos-rebuild switch --show-trace";
    };
  };

}
