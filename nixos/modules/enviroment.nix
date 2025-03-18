{
  pkgs,
  userSetting,
  inputs,
  outputs,
  ...
}: {
  # networking.nameservers = [
  #   "114.114.114.110"
  #   "185.228.168.168"
  # ];
  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mariadb;
  # };

  services.xserver.dpi = 192;
  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  # ircSession is the name of the new service we'll be creating

  services.emacs = {
    enable = true;
    # generate emacsclient desktop file
    package = import ./emacs.nix {inherit pkgs inputs;};
  };

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox-devedition}/bin/firefox-devedition";
  environment.systemPackages = with pkgs; [
    (import ./emacs.nix {inherit pkgs inputs;})
    # unstable.${pkgs.system}.chatgpt
    # inputs.ghostty.packages.${pkgs.system}.default
    # (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.flow-editor)
    # (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.gf)
    unstable.stm32cubemx
    # chromium
    # hexchat
    qemu
    librime
    nix-search
    # dash
    # wtype
    busybox
    toybox
    wine64
    # qbittorrent
    # sox
    # qemu_full
    # freecad-wayland
    # xorg.xinit
    file

    sdcv
    # qalculate-qt
    # qucs-s
    # ngspice
    #
    # xyce

    # (octaveFull.withPackages (ps:
    #   with ps; [
    #     symbolic
    #   ]))

    libtool
    okular
    jq
    pandoc
    # protonup
    nixfmt-classic
    ffmpeg
    # via
    paperlike-go
    quickemu
    # mangohud
    # neovim
    btop
    samba
    # ventoy-full
    # wineWowPackages.waylandFull
    unstable.helix

    # asusctl
    # bluez
    # bluez-tools
    # libsForQt5.bluez-qt
    gnumake
    # gcc
    alsa-utils
    cmake
    gnumake
    wget
  ];

  environment.etc = {
    "xdg/user-dirs.defaults".text = ''
      DESKTOP=
      DOWNLOAD=save
      TEMPLATES=
      PUBLICSHARE=
      DOCUMENTS=
      MUSIC=
      PICTURES=
      VIDEOS=
    '';
  };
  environment.shellAliases = {
    vi = "hx";
    qq = "hx";
    nano = "hx";
    np = "nix-shell -p";
    vim = "hx";
    nd = "pwd | wl-copy; pwd";
    rd = "..; z -";
    t = "z";
    ls = "ls --color=never";
    firefox = "firefox-devedition";
    rm = "rm -r";
    cp = "cp -r";
    # grep = "rg";
    weather = "curl wttr.in/chongqing";
    ff = "fd  | fzf | zoxide";
    c = "clear";
    e = "hx";
    unzip = "unzip -O gb18030";
    en = "hx .";
    r = "fg";
    re = "fg %1";
    cd = "z";
    sl = "ls";
    garbage = "nix-collect-garbage -d";
    get = "cd /etc/nixos/ && sudo sh update.sh";
    nixh = "nix-prefetch-url";
    nixhu = "nix-prefetch-url --unpack";
    rs = "sudo nixos-rebuild switch --flake /home/${userSetting.username}/config#${userSetting.hostname}";
    rb = "sudo nixos-rebuild boot --flake /home/${userSetting.username}/config#${userSetting.hostname}";
    rsu = "sudo nixos-rebuild switch --flake /home/${userSetting.username}/config#${userSetting.hostname}--upgrade";
    sh = "nix shell nixpkgs#";
    sys = "systemctl";
    sysu = "systemctl --user";
    up = "nixos-rebuild --flake .# build";
    upp = "doas nixos-rebuild --flake .# switch";
  };

  services.ollama.enable = false;

  services = {
    dictd = {
      enable = true;
      DBs = with pkgs.dictdDBs; [wiktionary wordnet];
    };
  };

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSetting.colorscheme}.yaml";
  # stylix.image = ./white.jpg;
  # stylix.enable = true;

  # stylix.cursor = {
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Ice";
  # };
  # stylix.polarity = "light";
  # stylix.fonts = {
  #   monospace = {
  #     package = pkgs.noto-fonts;
  #     name = "Noto Sans Mono";
  #   };
  #   sansSerif = {
  #     package = pkgs.source-han-sans;
  #     name = "Source Han Sans SC";
  #   };
  #   serif = {
  #     package = pkgs.noto-fonts;
  #     name = "Noto Serif";
  #   };
  #
  # monospace = {
  #   package = pkgs.nerd-fonts.noto;
  #   name = "Noto Sans Mono";
  # };
  # sansSerif = {
  #   package = pkgs.source-han-sans;
  #   name = "Source Han Sans SC";
  # };
  # serif = {
  #   package = pkgs.nerd-fonts.noto;
  #   name = "Noto Serif";
  # };
  # sizes = {
  #   applications = 17;
  #   terminal = 17;
  #   desktop = 17;
  #   popups = 17;
  # };
  # };

  environment.variables.EDITOR = "hx";
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # environment.variables = {
  #   GDK_SCALE = 2;
  # };
  #    NIX_LD_LIBRARY_PATH =with pkgs; lib.makeLibraryPath [
  #      pkgs.stdenv.cc.cc
  #      pkgs.openssl
  #      # ...
  #    ];
  #    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  #  };
  programs.nano.enable = false;
}
