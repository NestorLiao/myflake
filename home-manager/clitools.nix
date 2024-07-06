{
  # pkgs-unstable,
  pkgs,
  config,
  inputs,
  ...
}: {
  # imports = [
  #   inputs.nur-xddxdd.nixosModules.setupOverlay
  # ];

  home.packages = with pkgs; [
    # delta
    # thefuck
    # samba4Full
    # ffmpeg
    # pandoc
    kitty
    sdcv

    st
    gitui
    # gnome.cheese
    bat
    # helix-gpt
    nix-index
    # tectonic #Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive
    # tailscale #The node agent for Tailscale, a mesh VPN built on WireGuard
    # watchexec #Executes commands in response to file modifications
    # manix #A fast CLI documentation searcher for Nix.
    # mprocs #Run multiple commands in parallel
    # wiki-tui #A simple and easy to use Wikipedia Text User Interface
    # cargo-info #Query crates.io for crates details
    # scc #Sloc, Cloc and Code: scc is a very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
    just #just is a handy way to save and run project-specific commands.
    # bacon #bacon is a background rust code checker.
    samba

    # glxinfo
    # nvidia-system-monitor-qt
    # quickemu
    (quickemu.override {qemu = qemu_full;})
    # typst

    # gitui #git user interface for terminal
    # zathura #lightweight document viewer
    # uutils-coreutils-noprefix #collection of common Unix-like utilities without prefix
    killall #used to kill processes by name
    # bat #a cat clone with syntax highlighting and Git integration
    # ethtool #utility for displaying and modifying Ethernet device settings
    eza #command-line JSON processor
    fd #simple, fast and user-friendly alternative to `find`
    # imv #image viewer for the terminal
    neofetch #command-line system information tool
    nix-output-monitor #monitor build outputs of Nix package manager

    # pciutils #utilities for viewing and configuring PCI devices
    ripgrep #line-oriented search tool that recursively searches directories for a regex pattern
    # strace #diagnostic tool for debugging and profiling Linux processes
    # sysstat #collection of performance monitoring tools for Linux
    tldr #simplified and community-driven man pages
    tmux-sessionizer #tool for organizing and cleaning up tmux sessions
    # translate-shell #command-line translator using various translation services
    tree #displays directory structure in a tree-like format
    unrar-free #unarchiver for .rar files
    unzipNLS #decompression tool for .zip archives
    zip #compression tool and file packaging utility
    # usbutils #utilities for viewing USB devices and details
    # xdragon #(No specific description provided)
    # lm_sensors # for `sensors` command
    # lsof # list open files
    # ltrace # library call monitoring

    (pkgs.writeScriptBin "ts" ''
      #!/usr/bin/env bash

      # Execute wl-paste and store sse output in a variable
      clipboard_content=$(wl-paste)

      # Translate the clipboard content from English to Simplified Chinese using `trans`
      translated_content=$(sdcv -c -n "$clipboard_content" -u 牛津英汉双解美化版 -u WordNet)

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
    bash.enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = ["--cmd t"];
    enableFishIntegration = true;
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

  home.file.".config/fish/functions/mcdir.fish".text = ''
    function mcdir
      command mkdir $argv[1]
      and cd $argv[1]
    end
  '';

  home.file.".gitconfig".text = ''
    [core]
        pager = delta

    [interactive]
        diffFilter = delta --color-only

    [delta]
        navigate = true    # use n and N to move between diff sections

        # delta detects terminal colors automatically; set one of these to disable auto-detection
        # dark = true
        # light = true

    [merge]
        conflictstyle = diff3

    [diff]
        colorMoved = default
  '';

  home.file.".config/fish/functions/rcdir.fish".text = ''
    function rcdir
        while true
            read -l -P 'Do you want to continue? [y/N] ' confirm

            switch $confirm
                case Y y
                    rm -rf (pwd)
                    cd ..
                    return 0
                case \'\' N n
                    return 1
            end
        end
    end
  '';

  # xdg.configFile."clangd/config.yaml".text = ''
  #   CompileFlags:
  #     Add: [-std=c++20]
  # '';

  programs.command-not-found.enable = false;
}
