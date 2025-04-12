{ pkgs, userSetting, inputs, lib, outputs, ... }: {
  environment.systemPackages = with pkgs; [
    (import ./emacs.nix { inherit pkgs inputs; })
    fishPlugins.done
    fishPlugins.sponge

    # ch341eeprom
    cmake
    coreutils-full
    # wpsoffice-cn
    curl
    dash
    # qq
    fd
    ffmpeg
    file
    gcc
    gdb
    glibcInfo
    global
    gnumake
    # imsprog
    jq
    just
    leetcode-cli
    librime
    libtool
    libvterm
    linux-doc
    man-pages
    alsa-utils
    usbutils
    nixfmt-classic
    pandoc
    paperlike-go
    (python3.withPackages (python-pkgs:
      with python-pkgs; [
        requests
        promise
        # neurokit2
      ]))
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
      DOCUMENTS=save
      DOWNLOAD=save
      MUSIC=save/.media
      PICTURES=save
      PUBLICSHARE=/dev/null
      TEMPLATES=/dev/null
      VIDEOS=save
    '';
  };

  environment.shellAliases = {
    np = "nix-shell -p";
    gcl = "git clone";
    nd = "pwd | wl-copy; pwd";
    ls = "ls --color=never";
    rm = "rm -r";
    cp = "cp -r";
    weather = "curl wttr.in/chongqing";
    ff = "fd  | fzf | zoxide";
    c = "clear";
    unzip = "unzip -O gb18030";
    r = "fg";
    cd = "z";
    sl = "ls";
    lss = "ls";
    garbage = "nix-collect-garbage -d";
    nixh = "nix-prefetch-url";
    nixhu = "nix-prefetch-url --unpack";
    rs =
      "sudo nixos-rebuild switch --flake /home/${userSetting.username}/.config/nixos#${userSetting.hostname}";
    rb =
      "sudo nixos-rebuild boot --flake /home/${userSetting.username}/.config/nixos#${userSetting.hostname}";
    rsu =
      "sudo nixos-rebuild switch --flake /home/${userSetting.username}/.config/nixos#${userSetting.hostname}--upgrade";
    npi = "nix path-info nixpkgs#";
    sh = "nix shell nixpkgs#";
    sys = "systemctl";
    syss = "systemctl start";
    syssu = "systemctl status";
    sysst = "systemctl stop";
    sysr = "systemctl restart";
    sysu = "systemctl --user";
    sysus = "systemctl --user  start";
    sysusu = "systemctl --user  status";
    sysust = "systemctl --user  stop";
    sysur = "systemctl --user  restart";
    jo = "journalctl -xeu";
    vi = "emacsclient -a 'emacs'";
    nano = "emacsclient -a 'emacs'";
    vim = "emacsclient -a 'emacs'";
    e = "emacsclient -a 'emacs'";
    en = "emacsclient -a 'emacs' .";
  };

  services = {
    mysql = {
      enable = false;
      package = pkgs.mariadb;
    };
    ollama.enable = false;
    dictd = {
      enable = true;
      DBs = with pkgs.dictdDBs; [ wiktionary wordnet ];
    };
    xserver.dpi = 192;
    emacs = {
      enable = true;
      package = import ./emacs.nix { inherit pkgs inputs; };
    };
  };

  environment.variables = {
    EDITOR = "emacsclient -a 'emacs' &";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    GTK_IM_MODULE = lib.mkForce "";
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
