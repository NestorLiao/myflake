{pkgs, ...}: {
  environment.shellAliases = {
    cat = "bat";
    c = "clear";
    df = "duf";
    diff = "nvim -d";
    du = "gdu";
    e = "hx";
    en = "hx .";
    find = "fd";
    garbage = "nix-collect-garbage -d";
    get = "cd /etc/nixos/ && sudo sh update.sh";
    grep = "rg";
    la = "exa -a";
    ls = "eza";
    mann = "tldr";
    nixh = "nix-prefetch-url";
    nixhu = "nix-prefetch-url --unpack";
    nix = "nom";
    ping = "gping";
    py = "python";
    rb = "sudo nixos-rebuild boot";
    r = "fg";
    rs = "sudo nixos-rebuild switch --show-trace";
    rsu = "sudo nixos-rebuild switch --upgrade";
    sed = "sd";
    sh = "nix shell nixpkgs#";
    sys = "systemctl";
    sysu = "systemctl --user";
    top = "gotop";
    up = "nixos-rebuild --flake .# build";
    upp = "doas nixos-rebuild --flake .# switch";
    vi = "hx";
  };

  environment.variables.EDITOR = "hx";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs: (
              (base.targetPkgs pkgs)
              ++ [
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
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base
          // {
            name = "cuda-env";
            targetPkgs = pkgs:
              with pkgs; [
                git
                gitRepo
                gnupg
                autoconf
                curl
                procps
                gnumake
                util-linux
                m4
                gperf
                unzip
                cudatoolkit
                linuxPackages.nvidia_x11
                libGLU
                libGL
                xorg.libXi
                xorg.libXmu
                freeglut
                xorg.libXext
                xorg.libX11
                xorg.libXv
                xorg.libXrandr
                zlib
                ncurses5
                gcc11Stdenv.cc

                # stdenv.cc
                binutils
              ];
            multiPkgs = pkgs: with pkgs; [zlib];
            runScript = "fish";
            profile = ''
              export CUDA_PATH=${pkgs.cudatoolkit}
              # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
              export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
              export EXTRA_CCFLAGS="-I/usr/include"
            '';
          })
    )
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
