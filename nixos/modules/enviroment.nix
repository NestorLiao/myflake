{
  pkgs,
  userSetting,
  ...
}: {
  services.emacs.enable = true;
  services.emacs.package =
    import ./emacs.nix {inherit pkgs;};

  environment.systemPackages = with pkgs; [
    # protonup
    # via

    (import ./emacs.nix {inherit pkgs;})
    # mangohud
    neovim
    btop
    # samba
    # ventoy-full
    # wineWowPackages.waylandFull
    helix
    # asusctl
    # bluez
    # bluez-tools
    # libsForQt5.bluez-qt

    alsa-utils
    cmake
    gnumake
    # discord
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
    nd = "pwd | wl-copy; pwd";
    rd = "..; z -";
    t = "z";
    rm = "rm -r";
    cp = "cp -r";
    weather = "curl wttr.in/chongqing";
    ff = "fd  | fzf | zoxide";
    c = "clear";
    e = "hx";
    unzip = "unzip -O gb18030";
    en = "hx .";
    r = "fg";
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

  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;
  # programs.gamemode.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSetting.colorscheme}.yaml";
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-plateau-light.yaml";
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  # stylix.image = ./misuzu-kamio.jpeg;
  stylix.image = ./white.jpg;
  stylix.enable = true;

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };
  stylix.polarity = "light";
  stylix.fonts = {
    monospace = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Mono";
    };
    sansSerif = {
      package = pkgs.source-han-sans;
      name = "Source Han Sans SC";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };
    sizes = {
      applications = 18;
      terminal = 18;
      desktop = 18;
      popups = 18;
    };
  };

  environment.variables.EDITOR = "hx";
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # environment.variables = {
  #    NIX_LD_LIBRARY_PATH =with pkgs; lib.makeLibraryPath [
  #      pkgs.stdenv.cc.cc
  #      pkgs.openssl
  #      # ...
  #    ];
  #    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  #  };
  programs.nano.enable = false;
}
