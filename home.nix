{ inputs, config, pkgs, ... }:

{
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        randr
        rink
        shell
        symbols
        translate
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    # custom css for anyrun, based on catppuccin-mocha
    extraCss = ''
      #window {
        background: transparent;
      }
    '';
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    xwayland = { force_zero_scaling = "true"; };
    exec = [
      # "pkill waybar & sleep 0.5 && waybar"
      # "nm-applet --indicator &"
      # "dunst"
      ];
    exec-once = [
      "fcitx5 -d --replace" 
      "swaybg -i /home/randy/nink/nixos/wallpaper.jpg -m fill &"
      "wl-paste --type text --watch cliphist store"
    ];
    env = [
      "NIXOS_OZONE_WL,1"
      "XCURSOR_SIZE,24"
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];
    general = {
      gaps_in = "0";
      gaps_out = "0";
      border_size = "0";
      "col.active_border" = "rgba(ffffffff) rgba(ffffffff) 45deg";
      "col.inactive_border" = "rgba(ffffffff)";
      layout = "dwindle";
    };
    windowrulev2 = [ "rounding 0, xwayland:1, floating:1" ];
    decoration = {
      rounding = "7";
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
    master = { 
      new_is_master = "true"; 
      special_scale_factor = "0.8";
      no_gaps_when_only = "false";
    };
    gestures = { workspace_swipe = "off"; };
    # monitor = ",preferred,auto,1.5,transform,3";
    monitor = ",preferred,auto,1.5";
    # monitor = ",preferred,auto,1";
    "$mod" = "SUPER";
    bindm=[
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bind = [
      "$mod SHIFT, R, workspace,previous"
      "$mod, B, exec, vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --disable-gpu"
      "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$mod, A, exec, alacritty"
      "$mod, S, fullscreen"
      "$mod, C, killactive"
      "$mod, R, cyclenext"
      # "$mod  SHIFT, Q, exit"
      "$mod  SHIFT, H, exec, systemctl hibernate"
      "$mod  SHIFT, S, exec, systemctl suspend"
      "$mod, E, exec, thunar"
      "$mod, F, togglefloating"
      # "$mod, W, exec, pkill fuzzel || fuzzel"
      "$mod, W, exec, pkill anyrun || anyrun"
      "$mod, P, pseudo"
      "$mod, T, togglesplit"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, H, movewindow, l"
      "$mod, L, movewindow, r"
      "$mod, K, movewindow, u"
      "$mod, J, movewindow, d"
      ", Print, exec, grimblast copy area"
      "SHIFT, Print, exec, wf-recorder"
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
    # w3m-nox
    w3m
    lynx
    traceroute
    manix
    graph-easy
    slides
    mprocs
    bacon
    firefox
    gimp
    rofi
    imv
    wf-recorder
    qq
    # kitty
    grimblast
    # dunst
    cliphist
    swaybg
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
    wpsoffice-cn
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
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "\"" = ''"'';
            "`" = "`";
          };
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
      # theme = "papercolor-light";
      editor = {
        # gutters = ["diagnostics" "spacer" "diff"];
        auto-info = true;
        auto-save = true;
        file-picker.hidden = true;
        statusline = {
          left = [ "mode" "spinner" "file-name" 
            "diagnostics"
            "position-percentage"
            "position"
            "version-control" ];
          right = [
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
          skip-levels = 1;
        };
        lsp.display-messages = true;
        line-number = "relative";
        mouse = true;
        scrolloff = 3;
      };
      keys = {
        normal = {
          esc=["collapse_selection" "keep_primary_selection"];
          "C-h" = ":open ~/nink/nixos";
          "C-e" = ":open ~/nink/inklife";
          "C-p" = ":open /home/randy/playground";
          "\\" = ":reload-all";
          "X" = [ "extend_line_up" "extend_to_line_bounds" ];
          "A-x" = "extend_to_line_bounds";
          "g" = { "a" = "code_action"; };
          "A-s" = ":sh sudo nixos-rebuild switch --show-trace";
          "ret" = ["open_below" "normal_mode"];
          "A-ret" = ["open_above" "normal_mode"];
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
        normal.tab= {
          "m" = ":sh make 2>&1 || true";
          "s" = ":lsp-stop";
          "l" = ":lsp-restart";
          "r" = ":sh ./a 2>&1 || true";
        };


        # normal.ret= {
        #   "d" ="goto_prev_diag";
        #   "D" ="goto_first_diag";
        #   "f" ="goto_prev_function";
        #   "a" ="goto_prev_parameter";
        #   "c" ="goto_prev_comment";
        #   "T" ="goto_prev_test";
        #   "p" ="goto_prev_paragraph";
        #   "o" ="goto_prev_change";
        #   "G" ="goto_first_change";
        # };

        # normal.backspace= {
        #   "a" ="goto_next_diag";
        #   "A" ="goto_last_diag";
        #   "r" ="goto_next_function";
        #   "s" ="goto_next_class";
        #   "t" ="goto_next_parameter";
        #   "n" ="goto_next_comment";
        #   "e" ="goto_next_test";
        #   "i" ="goto_next_paragraph";
        #   "o" ="goto_next_change";
        #   "O" ="goto_last_change";
        # };

        normal."]"= {
          "]" ="goto_next_paragraph";
        };
        normal."["= {
          "[" ="goto_prev_paragraph";
        };
      };

    };
    themes = {
      eink = let
        white = "#FFFFFF";
        black = "#000000";
      in {
        "ui.background" = { bg = white; };
        "ui.text" = black;
        "ui.selection" = {
          bg = white;
          fg = black;
          modifiers = [ "bold" ];
          underline = {
            color = black;
            style = "curl";
          };
        };
        "ui.cursorline" = { bg = black; };
        "ui.statusline" = {
          bg = white;
          fg = black;
        };
        "ui.virtual.ruler" = { bg = black; };
        "ui.cursor.match" = { bg = black; };
        "ui.cursor" = {
          bg = black;
          fg = white;
        };
        "ui.cursorline.primary" = { bg = black; };
        "ui.linenr" = { fg = black; };
        "ui.linenr.selected" = {
          fg = black;
          bg = white;
        };
        "ui.menu" = {
          bg = white;
          fg = black;
        };
        "ui.menu.selected" = { bg = white; };
        "ui.popup" = { bg = white; };
        "ui.popup.info" = {
          bg = white;
          fg = black;
        };
        "ui.help" = {
          bg = white;
          fg = black;
        };
        "ui.window" = { bg = white; };
        "ui.statusline.normal" = {
          fg = black;
          bg = white;
        };
        "ui.statusline.insert" = {
          fg = black;
          bg = white;
        };
        "ui.statusline.select" = {
          fg = black;
          bg = white;
        };
        "diagnostic.error" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "constant.numeric" = { fg = black; };
        "constant.builtin" = { fg = black; };
        "keyword" = { fg = black; };
        "keyword.control" = { fg = black; };
        "keyword.function" = { fg = black; };
        "function" = { fg = black; };
        "function.macro" = {
          fg = black;
          modifiers = [ "bold" ];
        };
        "function.method" = { fg = black; };
        "function.builtin" = { fg = black; };
        "variable.builtin" = { fg = black; };
        "variable.other" = { fg = black; };
        "variable" = { fg = black; };
        "string" = black;
        "comment" = {
          fg = black;
          modifiers = [ "italic" ];
        };
        "namespace" = { fg = black; };
        "attribute" = { fg = black; };
        "type" = { fg = black; };
        "markup.heading" = {
          fg = black;
          modifiers = [ "bold" ];
        };
        "markup.raw" = { fg = black; };
        "markup.link.url" = { fg = black; };
        "markup.link.text" = { fg = black; };
        "markup.quote" = {
          fg = black;
          modifiers = [ "italic" ];
        };
        "diff.plus" = { fg = black; };
        "diff.delta" = { fg = black; };
        "diff.minus" = { fg = black; };
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
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy -in -selection clipboard'
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
      selection.save_to_clipboard = true;
      env.TERM = "xterm-256color";
      font = let family = "Noto Sans Mono"; in {
        size = 11;
        normal = {
          inherit family;
          style = "Medium";
        };
        bold = {
          inherit family;
          style = "Bold";
        };
        italic = {
          inherit family;
          style = "Italic";
        };
        bold_italic = {
          inherit family;
          style = "Bold";
        };
    };
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


 programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 7pt;
                 font-weight: bold;
                 border-radius: 5px;
                 transition-property: background-color;
                 transition-duration: 0.5s;
               }
               @keyframes blink_red {
                 to {
                   background-color: rgb(242, 143, 173);
                   color: rgb(26, 24, 38);
                 }
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                 background-color: transparent;
               }
               window > box {
                 margin-left: 5px;
                 margin-right: 5px;
                 margin-top: 5px;
                 background-color: #1e1e2a;
                 padding: 3px;
                 padding-left:8px;
                 border: 2px none #33ccff;
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 4px;
               }
         #workspaces button {
                 padding-top: 5px;
                 padding-bottom: 5px;
                 padding-left: 6px;
                 padding-right: 6px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background: rgb(48, 45, 65);
               }
               tooltip label {
                 color: rgb(217, 224, 238);
               }
         #custom-launcher {
                 font-size: 18px;
                 padding-left: 6px;
                 padding-right: 4px;
                 color: #7ebae4;
               }
         #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #memory {
                 color: rgb(181, 232, 224);
               }
         #cpu {
                 color: rgb(245, 194, 231);
               }
         #clock {
                 color: rgb(217, 224, 238);
               }
        /* #idle_inhibitor {
                 color: rgb(221, 182, 242);
               }*/
         #custom-wall {
                 color: #33ccff;
            }
         #temperature {
                 color: rgb(150, 205, 251);
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: rgb(245, 224, 220);
               }
         #network {
                 color: #ABE9B3;
               }
         #network.disconnected {
                 color: rgb(255, 255, 255);
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
                 padding-right: 8px;
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #mpd.paused {
                 color: #414868;
                 font-style: italic;
               }
         #mpd.stopped {
                 background: transparent;
               }
         #mpd {
                 color: #c0caf5;
               }
         #custom-cava-internal{
                 font-family: "Hack Nerd Font" ;
                 color: #33ccff;
               }
      '';
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
          "temperature"
          "mpd"
          "custom/cava-internal"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "memory"
          "cpu"
          "network"
          "custom/powermenu"
          "tray"
        ];
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "pkill rofi || rofi2";
          "on-click-middle" = "exec default_wall";
          "on-click-right" = "exec wallpaper_random";
          "tooltip" = false;
        };
        "custom/cava-internal" = {
          "exec" = "sleep 1s && cava-internal";
          "tooltip" = false;
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "pamixer -t";
          "tooltip" = false;
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          "tooltip-format"= "{=%A; %d %B %Y}\n<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰻠 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰍛 {usage}%";
        };
        "mpd" = {
          "max-length" = 25;
          "format" = "<span foreground='#bb9af7'></span> {title}";
          "format-paused" = " {title}";
          "format-stopped" = "<span foreground='#bb9af7'></span>";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc update; mpc ls | mpc add";
          "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };
        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰒢 Connected!";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩 {essid}";
          "interval" = 1;
          "tooltip" = false;
        };
        "custom/powermenu" = {
          "format" = "";
          "on-click" = "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 13;
          "spacing" = 3;
        };
      }];
    };


  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
