# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:


    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
    
    # Import modules
    ./modules

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    # useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      # Import your home-manager configuration
      randy = import ../home-manager/home.nix;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

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

  users.users.randy = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "plugdev" ];
    packages = with pkgs; [ ];
  };


  environment.variables.EDITOR = "hx";
  environment.systemPackages = with pkgs; [
    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
        name = "fhs";
        targetPkgs = pkgs: (
          (base.targetPkgs pkgs) ++ [
            pkgsi686Linux.glibc
            pkgsi686Linux.gcc
            # If your FHS program has additional dependencies, add them here
          ]
        );
        # multiArch = true;
        profile = "export FHS=1";
        runScript = "fish";
        extraOutputsToInstall = ["dev"];
      })
    )
    wget
    git
  ];


 # environment.variables = {
 #    NIX_LD_LIBRARY_PATH =with pkgs; lib.makeLibraryPath [
 #      pkgs.stdenv.cc.cc
 #      pkgs.openssl
 #      # ...
 #    ];
 #    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
 #  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva
    # pipewire.lib
    xorg.libxcb
    xorg.libXdamage
    xorg.libxshmfence
    xorg.libXxf86vm
    libelf
    # Required
    glib
    gtk2
    bzip2
    # Without these it silently fails
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXi
    xorg.libSM
    xorg.libICE
    gnome2.GConf
    nspr
    nss
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    ffmpeg
    # Only libraries are needed from those two
    libudev0-shim
    # Verified games requirements
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libidn
    tbb
    # Other things from runtime
    flac
    freeglut
    libjpeg
    libpng
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libdbusmenu-gtk2
    libindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    xorg.libXft
    libvdpau
    gnome2.pango
    cairo
    atk
    gdk-pixbuf
    fontconfig
    freetype
    dbus
    alsaLib
    expat
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
      set -x DIRENV_LOG_FORMAT ""
    '';
    shellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
      thefuck --alias | source 
      clear
    '';

    shellAbbrs = {
      "snr" = "sudo nixos-rebuild switch --show-trace";
      "find" = "fd";
      "py" = "python";
      "cr" = "cht.sh rust | less";
      "c" = "cht.sh | less";
      "e" = "hx";
      "en" = "hx .";
      "r" = "fg";
      # "diff" = "nvim -d";
      # "grep" = "rg";
      # "vi" = "hx";
      # "mann" = "tldr";
      # "tree" = "nnn";
      # "sed" = "sd";
      # "df" = "duf";
      # "du" = "gdu";
      # "ping" = "gping";
      # "mpc" = "vimpc";
      # "top" = "gotop";
      # "cat" = "bat";
      # "sh" = "nix shell nixpkgs#";
      # "nixh" = "nix-prefetch-url";
      # "nixhu" = "nix-prefetch-url --unpack";
      # "sys" = "systemctl";
      # "sysu" = "systemctl --user";
      # "up" = "nixos-rebuild --flake .# build";
      # "upp" = "doas nixos-rebuild --flake .# switch";
    };
  };
}
