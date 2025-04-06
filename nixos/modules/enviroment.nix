{
  pkgs,
  userSetting,
  inputs,
  lib,
  outputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (import ./emacs.nix {inherit pkgs inputs;})
    ch341eeprom
    cmake
    coreutils-full
    wpsoffice-cn
    curl
    dash
    fd
    fd
    ffmpeg
    file
    gcc
    gdb
    glibcInfo
    global
    gnumake
    imsprog
    jq
    just
    leetcode-cli
    librime
    libtool
    linux-doc
    man-pages
    nixfmt-classic
    pandoc
    paperlike-go
    # (unstable.python3.withPackages (python-pkgs: with python-pkgs; [
    #   requests
    #   promise
    #   neurokit2
    # ]))
    qemu_full
    quickemu
    ripgrep
    samba
    sdcv
    sqlite
    tldr
    tree
    unrar-free
    unzipNLS
    wget
    zip
  ];

  environment.etc = {
    "xdg/user-dirs.defaults".text = ''
      DESKTOP=/dev/null
      DOCUMENTS=files
      DOWNLOAD=files
      MUSIC=music
      PICTURES=files
      PUBLICSHARE=/dev/null
      TEMPLATES=/dev/null
      VIDEOS=files
    '';
  };

  environment.shellAliases = {
    vi = "hx";
    nano = "hx";
    np = "nix-shell -p";
    vim = "hx";
    nd = "pwd | wl-copy; pwd";
    ls = "ls --color=never";
    firefox = "firefox-beta";
    rm = "rm -r";
    cp = "cp -r";
    weather = "curl wttr.in/chongqing";
    ff = "fd  | fzf | zoxide";
    c = "clear";
    e = "hx";
    unzip = "unzip -O gb18030";
    en = "hx .";
    r = "fg";
    cd = "z";
    sl = "ls";
    lss = "ls";
    garbage = "nix-collect-garbage -d";
    nixh = "nix-prefetch-url";
    nixhu = "nix-prefetch-url --unpack";
    rs = "sudo nixos-rebuild switch --flake /home/${userSetting.username}/config#${userSetting.hostname}";
    rb = "sudo nixos-rebuild boot --flake /home/${userSetting.username}/config#${userSetting.hostname}";
    rsu = "sudo nixos-rebuild switch --flake /home/${userSetting.username}/config#${userSetting.hostname}--upgrade";
    npi = "nix path-info nixpkgs#";
    sh = "nix shell nixpkgs#";
    sys = "systemctl";
    syss = "systemctl start";
    syssu = "systemctl status";
    sysr = "systemctl restart";
    sysu = "systemctl --user";
    sysus = "systemctl --user  start";
    sysusu = "systemctl --user  status";
    sysur = "systemctl --user  restart";
    jo = "journalctl -xeu";
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    ollama.enable = false;
    dictd = {
      enable = true;
      DBs = with pkgs.dictdDBs; [wiktionary wordnet];
    };
    xserver.dpi = 192;
    emacs = {
      enable = true;
      package = import ./emacs.nix {inherit pkgs inputs;};
    };
  };

  environment.variables = {
    EDITOR = "emacsclient -a 'emacs'";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    GTK_IM_MODULE = lib.mkForce "";
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
