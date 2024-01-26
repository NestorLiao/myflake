{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    killall
    go-mtpfs
    quickemu
    zathura
    bacon
    bat
    cht-sh
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
    pciutils # lspci
    ripgrep
    strace # system call monitoring
    sysstat
    # system call monitoring
    # system tools
    thefuck
    tldr
    tmux-sessionizer
    translate-shell
    tree
    typst
    unrar-free
    unzip
    usbutils # lsusb
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
    userName = "cowboyliao";
    userEmail = "2730647052@qq.com";
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
    path = '${config.home.homeDirectory}/test/esp'
    depth = 10

  '';

  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
    prin " \n \n ╭───────┤ $(color 5) NixOS $(color 15)├───────╮"
    info " " kernel
    info " " wm
    info " " shell
    info " " term
    info "󰏖 " packages
    info "󰍛 " memory
    info "󰔛 " uptime
    prin " \n \n ╰─────────────────────────╯"
    }

    kernel_shorthand="on"
    uptime_shorthand="on"
    memory_percent="on"
    memory_unit="gib"
    package_managers="on"
    shell_path="off"
    shell_version="off"
    cpu_brand="off"
    cpu_speed="off"
    cpu_cores="off"
    cpu_temp="off"
    gpu_brand="on"
    gpu_type="all"
    refresh_rate="off"
    colors=(distro)
    bold="off"
    separator=""
    ascii_distro="NixOS"
    ascii_colors=(distro)
    ascii_bold="on"
    gap=1 # num -num
  '';
}
