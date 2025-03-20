{
  pkgs,
  userSetting,
  inputs,
  lib,
  outputs,
  ...
}: {
  # nixpkgs.config = {
  #   # Disable if you don't want unfree packages
  #   allowUnfree = true;
  #   # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #   allowUnfreePredicate = _: true;
  # };
  environment.systemPackages = with pkgs; [
    (import ./emacs.nix {inherit pkgs inputs;})
    fd
    curl
    sqlite
    file
    sdcv
    jq
    pandoc
    nixfmt-classic
    ffmpeg
    paperlike-go
    quickemu
    samba
    helix
    gnumake
    cmake
    wget
    coreutils-full
    libtool
    librime
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
    syss = "systemctl start";
    syssu = "systemctl status";
    sysr = "systemctl restart";
    sysu = "systemctl --user";
    sysus = "systemctl --user  start";
    sysusu = "systemctl --user  status";
    sysur = "systemctl --user  restart";
    jo="journalctl -xeu";
    up = "nixos-rebuild --flake .# build";
    upp = "doas nixos-rebuild --flake .# switch";
  };


  services = {
    mysql = {
      enable = false;
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
    EDITOR = "hx";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    GTK_IM_MODULE = lib.mkForce "";
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

}
