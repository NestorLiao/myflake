{ inputs, config, pkgs, ... }:

{
  home.username = "randy";
  home.homeDirectory = "/home/randy";
  home.packages = with pkgs; [
    fcitx5-configtool
    ripgrep
    neofetch
    nnn
    zip
    unzip
    ripgrep
    fzf
    qq
    gnome.cheese
    gdbgui
    lazygit
    lazycli
    gitui
    jetbrains.rust-rover
    vivaldi
    calibre
    wpsoffice
    tldr
    thefuck
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  programs.nixvim = {
    enable = true;
    # colorschemes.gruvbox.enable = true;
    plugins.lightline.enable = true;
    colorschemes.tokyonight = {
      enable = true;
      style = "day";
      transparent = false;
      terminalColors = false;
      dayBrightness = 1.0;
      dimInactive = true;
      styles = {
        comments = { italic = true; };
        keywords = { italic = false; };
        functions = { };
        variables = { };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language = [{
        name = "rust";
        auto-format = true;
      }];
      grammar = [{
        name = "rust";
        source = {
          git = "https://github.com/tree-sitter/tree-sitter-rust";
          rev = "0431a2c60828731f27491ee9fdefe25e250ce9c9";
        };
      }];

      language-server = {
        bash-language-server = {
          command =
            "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = [ "start" ];
        };

        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          clangd.fallbackFlags = [ "-std=c++2b" ];
        };

        vscode-css-language-server = {
          command =
            "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
          args = [ "--stdio" ];
        };
      };
    };
    settings = {
      # theme = "onelight";
      theme = "nord_light";
      editor = {
        auto-info = true;
        auto-save = true;
        file-picker.hidden = true;
        statusline = {
          left = [ "mode" "spinner" "file-name" ];
          right = [
            "diagnostics"
            "position-percentage"
            "position"
            "version-control"
          ];
          mode = {
            normal = "修";
            insert = "入";
            select = "选";
          };
        };
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = ''"'';
          "`" = "`";
        };
        soft-wrap = {
          enable = true;
          max-wrap = 25;
          max-indent-retain = 0;
          wrap-indicator = "";
        };
        indent-guides = {
          render = true;
          character = "╎";
          skip-levels = 0;
        };
        lsp.display-messages = true;
        line-number = "relative";
        mouse = false;
        scrolloff = 6;
      };
      keys = {
        normal = {
          "C-h" = ":open ~/nink/nixos";
          "C-e" = ":open ~/nink/inklife";
          "C-p" = ":open /home/randy/playground";
          "\\" = ":reload-all";

          "X" = [ "extend_line_up" "extend_to_line_bounds" ];
          "A-x" = "extend_to_line_bounds";
          "g" = { "a" = "code_action"; };
          "ret" = [ "open_below" "normal_mode" ];
          "A-ret" = [ "open_above" "normal_mode" ];
          "A-s" = ":sh sudo nixos-rebuild switch --show-trace";
        };
        select = { "X" = [ "extend_line_up" "extend_to_line_bounds" ]; };
        normal.space = {
          "e" = ":buffer-close";
          "q" = ":quit!";
          "n" = ":write";
          "space" = ":buffer-previous";
          "backspace" = ":buffer-next";
          "r" = ":sh cargo run 2>&1 || true";
          "t" = ":sh cargo test 2>&1 || true";
        };
      };

    };
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd j" ];
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "cowboyliao";
    userEmail = "2730647052@qq.com";
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [ sensible yank ];
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind-key -r Enter new-window -c "#{pane_current_path}"
      set  -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",alacritty:RGB"
      set-option -sa terminal-overrides ",xterm*:Tc"
      bind v copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind '"' split-window -v -c "#{pane_current_path}"
      bind-key x kill-pane
      bind % split-window -h -c "#{pane_current_path}"
      set -g status off
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = { size = 14; };
      colors = {
        primary = {
          background = "#ffffff";
          foreground = "#000000";
        };
        normal = {
          black = "#000000";
          red = "#000000";
          green = "#000000";
          yellow = "#000000";
          blue = "#000000";
          magenta = "#000000";
          cyan = "#000000";
          white = "#ffffff";
        };
        bright = {
          black = "#000000";
          red = "#000000";
          green = "#000000";
          yellow = "#000000";
          blue = "#000000";
          magenta = "#000000";
          cyan = "#000000";
          white = "#ffffff";
        };
      };
    };
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
