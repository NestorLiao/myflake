{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  systemd.network.networks.randy.dns = [  185.199.108.133 ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.sudo.wheelNeedsPassword = false;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
		# offload = {
		# 	enable = true;
		# 	enableOffloadCmd = true;
		# };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

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

  # services.xserver.displayManager.sddm= {
  #   enable=true;
  #   autoLogin.enable = true;
  #   autoLogin.user = "randy";
  # };
  # services.xserver.desktopManager.plasma5.enable=true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
        user = "randy";
      };
    };
  };


  programs.nano.enable = false;

  programs = {
    hyprland = {
      enable = true;
      xwayland = { enable = true; };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
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
      emoji = [ "Noto Color Emoji" ];
      monospace =
        [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono" ];
      sansSerif = [ "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans" ];
      serif = [ "Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif" ];
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
  nixpkgs.overlays = [ (self: super: { fcitx-engines = self.fcitx5; }) ];

  nix.settings.experimental-features = "nix-command flakes";

  services.xserver.layout = "us";

  sound.enable = true;
  security.rtkit.enable=true;
  services.pipewire={
    enable=true;
    alsa.enable=true;
    alsa.support32Bit=true;
    pulse.enable=true;
    jack.enable=true;
  };
  # hardware.pulseaudio.enable = true;

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
    networkmanagerapplet
    dunst
    evtest
    ffmpeg
    killall
    mpv
    lshw
    gdb
    # libsForQt5.bluedevil
    alsa-utils
    gnumake
    gcc
    cmake
    # xclip
    wl-clipboard
    wget
    clang-tools
    git
    alacritty
  ];

  nixpkgs.config.allowUnfree = true;



  nix.settings.trusted-users = [ "randy" ];
  users.defaultUserShell = pkgs.fish;
  environment.sessionVariables = {
    CHTSH_QUERY_OPTIONS= "T";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
      thefuck --alias | source 
      clear
    '';

    shellAbbrs = {
      "cr" = "cht.sh rust | less";
      "c" = "cht.sh | less";
      "e" = "hx";
      "en" = "hx .";
      "r" = "fg";
      "diff" = "nvim -d";
      "grep" = "rg";
      "vi" = "hx";
      "mann" = "tldr";
      "find" = "fd";
      "tree" = "nnn";
      "sed" = "sd";
      "df" = "duf";
      "du" = "gdu";
      "py" = "python";
      # "ping" = "gping";
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
  environment.variables.EDITOR = "hx";

  system.stateVersion = "23.11";

}
