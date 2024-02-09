{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    glxinfo
    nvidia-system-monitor-qt
    killall
    # go-mtpfs
    quickemu
    zathura
    bacon
    # bat
    ethtool
    eza
    fd
    fzf
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
    typst
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
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  programs.zoxide = {
    enable = true;
    options = ["--cmd j"];
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
}
