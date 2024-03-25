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
    rofi
    wf-recorder
    wl-clipboard
    pkgs.dconf
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "$mod, A, exec, alacritty"
        "$mod, B, exec, firefox"
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
        "$mod, E, workspace, +1"
        "$mod, I, workspace, -1"
        "$mod, P, pseudo"
        # "$mod, J, cyclenext"
        "$mod, R, workspace,previous"
        "$mod  SHIFT, Q, exit"
        "$mod, S, fullscreen"
        # "$mod  SHIFT, H, exec, systemctl hibernate"
        "$mod  SHIFT, S, fakefullscreen"
        "$mod, T, togglesplit"
        "$mod, up, movefocus, u"
        "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        "$mod, W, exec, pkill rofi || rofi -show drun "
        ", Print, exec, grimblast copy area"
        # ", PRINT, exec, grimblast save area - | convert png:- \\( +clone -alpha extract -draw 'fill black polygon 0,0 0,20 20,0 fill white circle 20,20 20,0' \\( +clone -flip \\) -compose Multiply -composite \\( +clone -flop \\) -compose Multiply -composite \\) -alpha off -compose CopyOpacity -composite png:- | convert png:- \\( +clone -background black -shadow 70x25+0+0 \\) +swap -background none -layers merge +repage png:- | wl-copy -t image/png"
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
      "fcitx5 -d --replace"
      "hyprctl dispatch workspace 5"
    ];
    env = [
      "MOZ_ENABLE_WAYLAND,1"
      "MOZ_WEBRENDER,1"
      "NIXOS_OZONE_WL,1"
      "XCURSOR_SIZE,24"
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];
    general = {
      sensitivity = "1";
      gaps_in = "0";
      gaps_out = "0";
      border_size = "0";
      "col.active_border" = "rgba(ffffffff) rgba(ffffffff) 45deg";
      "col.inactive_border" = "rgba(ffffffff)";
      layout = "dwindle";
    };
    windowrulev2 = [
      "rounding 0, xwayland:1, floating:1"
      "float, title:rofi.*"
      "float, title:QQ"
      "fakefullscreen,class:(firefox)"
      "float, title:图片查看器"
    ];
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
    windowrule = [
      "pseudo,fcitx"
    ];
    # windowrule = "pseudo";
    animations = {
      enabled = "no";
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
      new_is_master = "true";
      special_scale_factor = "0.8";
      no_gaps_when_only = "false";
    };
    gestures = {workspace_swipe = "off";};
    monitor = [
      ",1920x1080@60,0x0,1,transform,1"
      "HDMI-A-1,1920x1080@60,1080x0,1,transform,0"
      # "HDMI-A-1,1920x1080@60,1080x0,1,transform,3"
    ];
    workspace = [
      "1, monitor:DP-2, default:true"
      "4, monitor:DP-2, default:true"
      "7, monitor:DP-2, default:true"
      "1, monitor:DP-1, default:true"
      "4, monitor:DP-1, default:true"
      "7, monitor:DP-1, default:true"
      "2, monitor:HDMI-A-1, default:true"
      "3, monitor:HDMI-A-1, default:true"
      "5, monitor:HDMI-A-1, default:true"
      "6, monitor:HDMI-A-1, default:true"
      "8, monitor:HDMI-A-1, default:true"
      "9, monitor:HDMI-A-1, default:true"
    ];
    "$mod" = "SUPER";
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
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
}
