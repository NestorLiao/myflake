{
  pkgs,
  userSetting,
  ...
}: {
  environment.shellAliases = {
    nd = "pwd | wl-copy; pwd";
    rd = "..; z -";
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
      applications = 12;
      terminal = 12;
      desktop = 12;
      popups = 12;
    };
  };

  environment.variables.EDITOR = "hx";
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  environment.systemPackages = with pkgs; [
    # protonup
    via
    # mangohud
    neovim
    btop
    # samba
    # ventoy-full
    wineWowPackages.waylandFull
    # bluez
    # bluez-tools
    # libsForQt5.bluez-qt

    alsa-utils
    # discord
    wget
    # (
    #   let
    #     base = pkgs.appimageTools.defaultFhsEnvArgs;
    #   in
    #     pkgs.buildFHSUserEnv (base
    #       // {
    #         name = "fhs";
    #         targetPkgs = pkgs: (
    #           (base.targetPkgs pkgs)
    #           ++ [
    #             stm32cubemx
    #             # If your FHS program has additional dependencies, add them here
    #           ]
    #         );
    #         # multiArch = true;
    #         profile = "export FHS=1";
    #         runScript = "bash";
    #         extraOutputsToInstall = ["dev"];
    #       })
    # )
    # (
    #   let
    #     base = pkgs.appimageTools.defaultFhsEnvArgs;
    #   in
    #     pkgs.buildFHSUserEnv (base
    #       // {
    #         name = "fhs";
    #         targetPkgs = pkgs: (
    #           (base.targetPkgs pkgs)
    #           ++ [
    #             pkgsi686Linux.glibc
    #             pkgsi686Linux.gcc
    #             # If your FHS program has additional dependencies, add them here
    #           ]
    #         );
    #         # multiArch = true;
    #         profile = "export FHS=1";
    #         runScript = "fish";
    #         extraOutputsToInstall = ["dev"];
    #       })
    # )

    # (
    #   let
    #     base = pkgs.appimageTools.defaultFhsEnvArgs;
    #   in
    #     pkgs.buildFHSUserEnv (base
    #       // {
    #         name = "cuda-env";
    #         targetPkgs = pkgs:
    #           with pkgs; [
    #             git
    #             gitRepo
    #             gnupg
    #             autoconf
    #             curl
    #             procps
    #             gnumake
    #             util-linux
    #             m4
    #             gperf
    #             unzip
    #             cudatoolkit
    #             linuxPackages.nvidia_x11
    #             libGLU
    #             libGL
    #             xorg.libXi
    #             xorg.libXmu
    #             freeglut
    #             xorg.libXext
    #             xorg.libX11
    #             xorg.libXv
    #             xorg.libXrandr
    #             zlib
    #             ncurses5
    #             gcc11Stdenv.cc
    #             stdenv.cc
    #             binutils
    #           ];
    #         multiPkgs = pkgs: with pkgs; [zlib];
    #         runScript = "fish";
    #         profile = ''
    #           export CUDA_PATH=${pkgs.cudatoolkit}
    #           # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
    #           export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    #           export EXTRA_CCFLAGS="-I/usr/include"
    #         '';
    #       })
    # )
    # (
    #   let
    #     base = pkgs.appimageTools.defaultFhsEnvArgs;
    #   in
    #     pkgs.buildFHSUserEnv (base
    #       // {
    #         name = "cuda-but124";
    #         targetPkgs = pkgs:
    #           with pkgs; [
    #             git
    #             gitRepo
    #             gnupg
    #             autoconf
    #             curl
    #             procps
    #             gnumake
    #             util-linux
    #             m4
    #             gperf
    #             unzip
    #             (cudatoolkit.override
    #               {cudaVersion = "10.0";})
    #             # https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run
    #             linuxPackages.nvidia_x11
    #             libGLU
    #             libGL
    #             xorg.libXi
    #             xorg.libXmu
    #             freeglut
    #             xorg.libXext
    #             xorg.libX11
    #             xorg.libXv
    #             xorg.libXrandr
    #             zlib
    #             ncurses5
    #             gcc12Stdenv.cc
    #             # stdenv.cc
    #             binutils
    #           ];
    #         multiPkgs = pkgs: with pkgs; [zlib];
    #         runScript = "fish";
    #         profile = ''
    #           export CUDA_PATH=${pkgs.cudatoolkit}
    #           # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
    #           export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    #           export EXTRA_CCFLAGS="-I/usr/include"
    #         '';
    #       })
    # )
    # (
    #   let
    #     base = pkgs.appimageTools.defaultFhsEnvArgs;
    #   in
    #     pkgs.buildFHSUserEnv (base
    #       // {
    #         name = "cuda-but13";
    #         targetPkgs = pkgs:
    #           with pkgs; [
    #             git
    #             gitRepo
    #             gnupg
    #             autoconf
    #             curl
    #             procps
    #             gnumake
    #             util-linux
    #             m4
    #             gperf
    #             unzip
    #             cudatoolkit
    #             linuxPackages.nvidia_x11
    #             libGLU
    #             libGL
    #             xorg.libXi
    #             xorg.libXmu
    #             freeglut
    #             xorg.libXext
    #             xorg.libX11
    #             xorg.libXv
    #             xorg.libXrandr
    #             zlib
    #             ncurses5
    #             gcc13Stdenv.cc
    #             # stdenv.cc
    #             binutils
    #           ];
    #         multiPkgs = pkgs: with pkgs; [zlib];
    #         runScript = "fish";
    #         profile = ''
    #           export CUDA_PATH=${pkgs.cudatoolkit}
    #           # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
    #           export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    #           export EXTRA_CCFLAGS="-I/usr/include"
    #         '';
    #       })
    # )
  ];

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
