{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    scc
    just
    bacon

    uutils-coreutils-noprefix
    # glxinfo
    # nvidia-system-monitor-qt
    killall
    # quickemu
    zathura
    bat
    ethtool
    eza
    fd
    gitui
    imv
    lm_sensors # for `sensors` command
    lsof # list open files
    ltrace # library call monitoring
    manix
    mprocs
    neofetch
    nix-output-monitor
    pciutils
    ripgrep
    strace
    sysstat
    tldr
    tmux-sessionizer
    translate-shell
    tree
    # typst
    unrar-free
    unzip
    zip
    usbutils
    xdragon
    (pkgs.writeScriptBin "ts" ''
      #!/usr/bin/env bash

      # Execute wl-paste and store the output in a variable
      clipboard_content=$(wl-paste)

      # Translate the clipboard content from English to Simplified Chinese using `trans`
      translated_content=$(echo "$clipboard_content" | trans :zh)

      # Remove ANSI escape codes from the translated content using `sed`
      cleaned_content=$(echo "$translated_content" | sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g")

      # Print the final cleaned content
      echo "$cleaned_content"
    '')
  ];

  programs = {
    fzf = {
      enable = false;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  # programs.zsh = {
  #   oh-my-zsh = {
  #     enable = true;
  #     plugins = ["git" "thefuck" "zsh-autocomplete"];
  #   };
  # };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
      eval "$(zoxide init bash)"
    '';

    # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
    # shellAliases = {
    #   k = "kubectl";
    #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    # };
  };

  programs.zoxide = {
    enable = true;
    options = ["--cmd t"];
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Cowboyliao";
    userEmail = "2730647025@qq.com";
    lfs.enable = true;
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
    };
  };

  # TODO: find some way to express this as an attrset, and then convert to toml,
  # instead of hand-writing the toml
  home.file.${
    if pkgs.stdenv.isDarwin
    then "/Library/Application Support/rs.tms/default-config.toml"
    else ".config/tms/default-config.toml"
  }.text = ''
    search_paths = []

    [[search_dirs]]
    path = '${config.home.homeDirectory}/nink/nixos'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/training/CSAPP2Rust'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/playground/cowboyliao.github.io'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/playground/rust'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/test/esp'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/playground/cuda'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/playground/matlab'
    depth = 10

  '';

  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        info "System" distro
        info "Kernel" kernel
        info "Environment" de
        info "Uptime" uptime
        info "Packages" packages
        info "CPU" cpu
        info "GPU" gpu
        info "Memory" memory
        info "Disk" disk
        info "Local IP" local_ip
        info "Public IP" public_ip
    }

    distro_shorthand="on"
    os_arch="on"
    uptime_shorthand="tiny"
    package_managers="on"
    public_ip_host="https://ident.me"
    de_version="on"
    disk_subtitle="none"
    separator=" =="
    ascii_distro="auto"
    image_size="auto"
  '';

  # # 启用 starship，这是一个漂亮的 shell 提示符
  # programs.starship = {
  #   enable = false;
  #   # 自定义配置
  #   settings = {
  #     add_newline = false;
  #     aws.disabled = true;
  #     gcloud.disabled = true;
  #     line_break.disabled = true;
  #   };
  # };

  # # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".cargo/config".text = ''
  #   [source.crates-io]
  #   replace-with = 'rsproxy-sparse'
  #   [source.rsproxy]
  #   registry = "https://rsproxy.cn/crates.io-index"
  #   [source.rsproxy-sparse]
  #   registry = "sparse+https://rsproxy.cn/index/"
  #   [registries.rsproxy]
  #   index = "https://rsproxy.cn/crates.io-index"
  #   [net]
  #   git-fetch-with-cli = true
  # '';
}
