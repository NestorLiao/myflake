{ inputs, config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    xwayland = { force_zero_scaling = "true"; };
    exec-once = [ "fcitx5 -d --replace" ];
    env = [
      "XCURSOR_SIZE,24"
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];
    general = {
      gaps_in = "0";
      gaps_out = "0";
      border_size = "1";
      "col.active_border" = "rgba(ffffffff) rgba(ffffffff) 45deg";
      "col.inactive_border" = "rgba(00000000)";
      layout = "dwindle";
    };
    windowrulev2 = [ "rounding 0, xwayland:1, floating:1" ];
    decoration = {
      rounding = "0";
      blur = {
        enabled = "false";
        size = "3";
        passes = "1";
      };
      drop_shadow = "no";
      shadow_range = "0";
      shadow_render_power = "0";
      "col.shadow" = "rgba(00000000)";
    };
    windowrule = "pseudo,fcitx";
    animations = {
      enabled = "no";
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
    dwindle = {
      pseudotile =
        "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = "yes"; # you probably want this
    };
    master = { new_is_master = "true"; };
    gestures = { workspace_swipe = "off"; };
    monitor = ",preferred,auto,1.5,transform,3";
    "$mod" = "SUPER";
    bind = [
      "$mod, F, exec, vivaldi --enable-wayland-ime"
      "$mod, Q, exec, alacritty"
      "$mod, F11, fullscreen"
      "$mod, C, killactive"
      "$mod, R, cyclenext"
      "$mod, M, exit"
      "$mod, E, exec, thunar"
      "$mod, V, togglefloating"
      "$mod, W, exec, pkill fuzzel || fuzzel"
      "$mod, P, pseudo"
      "$mod, J, togglesplit"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      ", Print, exec, grimblast copy area"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]) 10));
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-White";
    };
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };

  home.username = "randy";
  home.homeDirectory = "/home/randy";
  home.packages = with pkgs; [
    # dunst
    # cliphist
    # slurp
    fuzzel
    xfce.thunar
    tmux-sessionizer
    # intel-gpu-tools
    # glmark2
    ripgrep
    neofetch
    nnn
    cht-sh
    zip
    unzip
    ripgrep
    fzf
    fd
    gnome.cheese
    gitui
    vivaldi
    calibre
    # wpsoffice
    libreoffice
    tldr
    thefuck
    glxinfo
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      markdown = [{
        name = "markdown";
        file-types = [ "md" "mdx" "markdown" ];
        text-width = 80;
        soft-wrap = {
          enable = true;
          wrap-at-text-width = true;
        };
      }];
      rust = [{
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
      theme = "eink";
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
          "l" = ":sh tmux split-window -v -p 70 ";
          "r" = ":sh cargo run 2>&1 || true";
          "t" = ":sh cargo test 2>&1 || true";
        };
      };

    };
    themes = {
      eink = let
        white = "#FFFFFF";
        blake = "#000000";
      in {
        "ui.background" = { bg = white; };
        "ui.text" = blake;
        "ui.selection" = {
          bg = white;
          fg = blake;
          modifiers = [ "bold" ];
          underline = {
            color = blake;
            style = "curl";
          };
        };
        "ui.cursorline" = { bg = blake; };
        "ui.statusline" = {
          bg = white;
          fg = blake;
        };
        "ui.virtual.ruler" = { bg = blake; };
        "ui.cursor.match" = { bg = blake; };
        "ui.cursor" = {
          bg = blake;
          fg = white;
        };
        "ui.cursorline.primary" = { bg = blake; };
        "ui.linenr" = { fg = blake; };
        "ui.linenr.selected" = {
          fg = blake;
          bg = white;
        };
        "ui.menu" = {
          bg = white;
          fg = blake;
        };
        "ui.menu.selected" = { bg = white; };
        "ui.popup" = { bg = white; };
        "ui.popup.info" = {
          bg = white;
          fg = blake;
        };
        "ui.help" = {
          bg = white;
          fg = blake;
        };
        "ui.window" = { bg = white; };
        "ui.statusline.normal" = {
          fg = blake;
          bg = white;
        };
        "ui.statusline.insert" = {
          fg = blake;
          bg = white;
        };
        "ui.statusline.select" = {
          fg = blake;
          bg = white;
        };
        "diagnostic.error" = {
          underline = {
            color = blake;
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = blake;
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = blake;
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = blake;
            style = "curl";
          };
        };
        "constant.numeric" = { fg = blake; };
        "constant.builtin" = { fg = blake; };
        "keyword" = { fg = blake; };
        "keyword.control" = { fg = blake; };
        "keyword.function" = { fg = blake; };
        "function" = { fg = blake; };
        "function.macro" = {
          fg = blake;
          modifiers = [ "bold" ];
        };
        "function.method" = { fg = blake; };
        "function.builtin" = { fg = blake; };
        "variable.builtin" = { fg = blake; };
        "variable.other" = { fg = blake; };
        "variable" = { fg = blake; };
        "string" = blake;
        "comment" = {
          fg = blake;
          modifiers = [ "italic" ];
        };
        "namespace" = { fg = blake; };
        "attribute" = { fg = blake; };
        "type" = { fg = blake; };
        "markup.heading" = {
          fg = blake;
          modifiers = [ "bold" ];
        };
        "markup.raw" = { fg = blake; };
        "markup.link.url" = { fg = blake; };
        "markup.link.text" = { fg = blake; };
        "markup.quote" = {
          fg = blake;
          modifiers = [ "italic" ];
        };
        "diff.plus" = { fg = blake; };
        "diff.delta" = { fg = blake; };
        "diff.minus" = { fg = blake; };
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
      bind-key -r Bspace kill-pane
      bind-key -r Enter split-window -v -p 20 -c "#{pane_current_path}"
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
      font = { size = 11; };
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
