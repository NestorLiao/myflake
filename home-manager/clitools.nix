{
  # pkgs-unstable,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nur-xddxdd.nixosModules.setupOverlay
  ];

  home.packages = with pkgs; [
    tectonic #Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive
    tailscale #The node agent for Tailscale, a mesh VPN built on WireGuard
    linux-wifi-hotspot #Feature-rich wifi hotspot creator for Linux which provides both GUI and command-line interface
    watchexec #Executes commands in response to file modifications
    manix #A fast CLI documentation searcher for Nix.
    mprocs #Run multiple commands in parallel
    wiki-tui #A simple and easy to use Wikipedia Text User Interface
    cargo-info #Query crates.io for crates details
    scc #Sloc, Cloc and Code: scc is a very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
    just #just is a handy way to save and run project-specific commands.
    bacon #bacon is a background rust code checker.

    # glxinfo
    # nvidia-system-monitor-qt
    quickemu
    # typst

    gitui #git user interface for terminal
    zathura #lightweight document viewer
    uutils-coreutils-noprefix #collection of common Unix-like utilities without prefix
    killall #used to kill processes by name
    # bat #a cat clone with syntax highlighting and Git integration
    ethtool #utility for displaying and modifying Ethernet device settings
    eza #command-line JSON processor
    fd #simple, fast and user-friendly alternative to `find`
    # imv #image viewer for the terminal
    neofetch #command-line system information tool
    nix-output-monitor #monitor build outputs of Nix package manager

    pciutils #utilities for viewing and configuring PCI devices
    ripgrep #line-oriented search tool that recursively searches directories for a regex pattern
    strace #diagnostic tool for debugging and profiling Linux processes
    sysstat #collection of performance monitoring tools for Linux
    tldr #simplified and community-driven man pages
    tmux-sessionizer #tool for organizing and cleaning up tmux sessions
    translate-shell #command-line translator using various translation services
    tree #displays directory structure in a tree-like format
    unrar-free #unarchiver for .rar files
    unzip #decompression tool for .zip archives
    zip #compression tool and file packaging utility
    usbutils #utilities for viewing USB devices and details
    xdragon #(No specific description provided)
    lm_sensors # for `sensors` command
    lsof # list open files
    ltrace # library call monitoring

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
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
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
    userName = "NestorLiao";
    userEmail = "gtkndcbfhr@gmail.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
    };
  };

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

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  home.file.".config/wiki-tui/config.toml".source =
    ./wiki-tui.toml;

  home.file.".cargo/config.toml".source =
    ./CargoConf.toml;
}