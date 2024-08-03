{
  pkgs,
  userSetting,
  lib,
  ...
}:
lib.mkIf (userSetting.windowmanager == "hyprland") {
  home.packages = with pkgs; [
    cliphist
    grimblast
    hyprpicker
    # rofi-wayland-unwrapped
    wf-recorder
    wl-clipboard
    hyprpaper
    pkgs.dconf
  ];

  stylix.targets.tofi.enable = false;
  programs.tofi = {
    enable = true;
    settings = {
      anchor = "top";
      width = "100%";
      height = 30;
      horizontal = true;
      font-size = 14;
      prompt-text = " run: ";
      font = "monospace";
      outline-width = 0;
      border-width = 0;
      background-color = "#ffffff";
      text-color = "#000000";

      # # Selection text
      selection-color = "#ffffff";
      selection-background = "#000000";
      # selection-match-color = "#00000000";
      # selection-background-padding = 2;
      # selection-background-corner-radius = 2;
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 0;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
    };
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "$mod, A, exec, alacritty"
        "$mod, B, exec, firefox"
        "$mod, R, exec, emacsclient -c -a 'emacs'"
        # "$mod, R, exec, emacs"
        ",code:87, workspace,1"
        ",code:88, workspace,2"
        ",code:89, workspace,3"
        ",code:83, workspace,4"
        ",code:84, workspace,5"
        ",code:85, workspace,6"
        ",code:79, workspace,7"
        ",code:80, workspace,8"
        ",code:81, workspace,9"
        ",code:90, cyclenext"
        "$mod, C, killactive"
        "$mod, down, movefocus, d"
        "$mod, D, exec,"
        "$mod, F, togglefloating"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod, N, movefocus, l"
        "$mod, O, movefocus, r"
        "$mod, E, movefocus, d"
        "$mod, I, movefocus, u"
        "$mod, P, pseudo"
        "$mod, J, cyclenext"
        "$mod  SHIFT, R, workspace,previous"
        "$mod  SHIFT, Q, exit"
        "$mod, S, fullscreen"
        "$mod  SHIFT, H, exec, systemctl hibernate"
        "$mod, X, fakefullscreen"
        "$mod  SHIFT, P, pin"
        "$mod, T, togglesplit"
        "$mod, up, movefocus, u"
        "$mod, V, exec, cliphist list | tofi | cliphist decode | wl-copy"
        # "$mod, W, exec, pkill tofi || tofi-drun --drun-launch=true "
        "$mod, W, exec, tofi-drun --drun-launch=true "
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, wf-recorder"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ])
          10)
      );

    xwayland = {force_zero_scaling = "true";};
    exec-once = [
      "cp ~/.config/fcitx5/profile-bak ~/.config/fcitx5/profile"
      "systemctl --user start xremap"
      "wl-paste --type text --watch cliphist store"
      # "fcitx5 -d --replace"
      # "fcitx5-remote -r"
      "hyprctl dispatch workspace 4"
      "hyprpaper"
      # "ags"
    ];
    env = [
      "XMODIFIERS, @im=fcitx"
      "QT_IM_MODULE, fcitx"
      "SDL_IM_MODULE, fcitx"
      "GDK_BACKEND, wayland,x11"
      "QT_QPA_PLATFORM, wayland;xcb"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
      "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
      "CLUTTER_BACKEND, wayland"
      "ADW_DISABLE_PORTAL, 1"
      "XCURSOR_SIZE,24"
      # "XCURSOR_THEME,Dracula-cursors"
      # "HYPRCURSOR_THEME,hyprcursor_Dracula"
      # "HYPRCURSOR_SIZE,24"
      # "LANGUAGE, zh_CN:en_US"

      # "QT_QPA_PLATFORM,wayland;xcb"
      # "CLUTTER_BACKEND,wayland"
      # "SDL_VIDEODRIVER,wayland"
      # "XDG_SESSION_TYPE,wayland"
      # "XDG_CURRENT_DESKTOP,hyprland"

      # "QT_QPA_PLATFORMTHEME,qt5ct"

      # "GLFW_IM_MODULE,fcitx"
      # "GTK_IM_MODULE,fcitx"
      # "INPUT_METHOD,fcitx"
      # "XMODIFIERS,@im=fcitx"
      # "IMSETTINGS_MODULE,fcitx"
      # "QT_IM_MODULE,fcitx"

      "MOZ_ENABLE_WAYLAND,1"
      "MOZ_WEBRENDER,1"
      # "NIXOS_OZONE_WL,1"
      # "XCURSOR_SIZE,24"
      # "_JAVA_AWT_WM_NONREPARENTING,1"
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];
    general = {
      sensitivity = "1.2";
      gaps_in = "0";
      gaps_out = "0";
      border_size = "0";
      # "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
      # "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
      # "col.active_border" = "rgba(ffffffff) rgba(ffffffff) 0deg";
      # "col.inactive_border" = "rgba(ffffffff) rgba(ffffffff) 0deg";
      layout = "dwindle";
      # no_focus_fallback = true;
      # resize_on_border = true;
    };

    # group = {
    #   "col.border_active" = " rgba(E1A2B7ff) rgba(522936ff) 45deg";
    #   "col.border_inactive" = " rgba(2F364Acc) rgba(76C4D7cc) 45deg";
    #   "col.border_locked_active" = " rgba(0F0F11ff) rgba(090A0Aff) 45deg";
    #   "col.border_locked_inactive" = " rgba(FFFFFFcc) rgba(0F0E0Dcc) 45deg";
    # };

    misc = {
      disable_autoreload = false;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      animate_mouse_windowdragging = false;
    };

    windowrule = [
      "float,title:^(Open File)(.*)$"
      "float,title:^(Open Folder)(.*)$"
      "float,title:^(Save As)(.*)$"
      "float,title:^(Library)(.*)$ "
      "nofocus,title:^(.*)(mvi)$"
    ];

    windowrulev2 = [
      "float, class:^(.*fcitx.*)$"
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
      # "opacity 1.0 override 1.0 override, class:^(Google-chrome)$"
      # "opacity 0.9 override 0.9 override, class:^(QQ)$"
      "float, class:^(QQ)$"
      "float, class:^(kruler)$"
      "float,title:^(查看媒体)$|^(图片查看)$|^(图片查看器)$|^(KDE)$"
      "float, class:^(yuri)$"
      "float, class:^(jetbrains-studio)$"
      "float, class:^(feishu)$"
      "size 75% 75%, class:^(QQ)$"
      "center, class:^(QQ)$"
      "fakefullscreen,class:(firefox)"
      # "size 75% 75%, class:^(STM32CubeMX)$"
      # "center, class:^(STM32CubeMX)$"

      "float, title:tofi.*"
      # "rounding 0, xwayland:1"
      # "float, title:QQ"
      # "float, title:图片查看器"

      # "size 640 400, ,float,class:(main), title:(App)"
      # "size 640 400,move 100 100,float,forceinput,immediate,title:^(App)$"
      "float,forceinput,immediate,title:^(App)$"
      # "size 640 400,title:^(App)$"
    ];
    decoration = {
      rounding = "0";
      blur = {
        enabled = "false";
        size = "3";
        passes = "1";
      };
      shadow_range = "0";
      shadow_render_power = "4";
      drop_shadow = false;
      active_opacity = "1.0";
      inactive_opacity = "1.0";
      fullscreen_opacity = "1.0";
    };
    animations = {
      enabled = false;
      first_launch_animation = false;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      # animation = [
      #   "windows, 1, 7, myBezier"
      #   "windowsOut, 1, 7, default, popin 80%"
      #   "border, 1, 10, default"
      #   "borderangle, 1, 8, default"
      #   "fade, 1, 7, default"
      #   "workspaces, 1, 6, default"
      # ];
    };
    dwindle = {
      pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = "yes"; # you probably want this
    };
    master = {
      # new_is_master = "true";
      special_scale_factor = "0.8";
      no_gaps_when_only = "false";
    };
    gestures = {workspace_swipe = "off";};
    monitor = [
      # ",preferred,0x0,1.66666,transform,0"
      ",preferred,0x0,2,transform,0"
      # ",preferred,0x0,1,transform,0"
      # "DP-2,preferred,1920x0,1,transform,0"
      # ",preferred,1920x-420,1,transform,1"
      # ",preferred,1080x0,1,transform,1"
      # ",preferred,1920x0,1,transform,0"
      # "DP-1,preferred,1920x-420,1,transform,1"
      # "DP-2,preferred,1920x-420,1,transform,1"
      # "HDMI-A-1,preferred,auto,1,transform,0"
      # "HDMI-A-1,1920x1080@60,1080x0,1,transform,0"
      # "HDMI-A-1,1920x1080@60,1080x0,1,transform,3"

      # ",preferred,1920x0,1,transform,0"
      # "HDMI-A-2,disable"
      # "HDMI-A-1,1920x1080@60,0x0,1,transform,0"
    ];
    workspace = [
      "0, monitor:DP-2, default:true"
      "9, monitor:DP-2, default:true"
      "6, monitor:DP-2, default:true"
      "3, monitor:DP-2, default:true"
      "0, monitor:DP-1, default:true"
      "9, monitor:DP-1, default:true"
      "6, monitor:DP-1, default:true"
      "3, monitor:DP-1, default:true"

      "4, monitor:HDMI-A-1, default:true"
      "7, monitor:HDMI-A-1, default:true"
      "8, monitor:HDMI-A-1, default:true"
      "5, monitor:HDMI-A-1, default:true"
      "2, monitor:HDMI-A-1, default:true"
      "1, monitor:HDMI-A-1, default:true"
      "1, monitor:HDMI-A-1, default:true"
    ];
    "$mod" = "SUPER";
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Ice";
  #   size = 16;
  # };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     package = pkgs.flat-remix-gtk;
  #     name = "Flat-Remix-GTK-White";
  #   };
  #   # iconTheme = {
  #   #   package = pkgs.adwaita-icon-theme;
  #   #   name = "Adwaita";
  #   # };
  #   # font = {
  #   #   name = "Sans";
  #   #   size = 11;
  #   # };
  # };
}
