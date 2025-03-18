{
  pkgs,
  userSetting,
  lib,
  inputs,
  ...
}: let
  # Define the script content for toggling workspaces
  toggleSpeechtotextScript = ''
    #!/usr/bin/env bash
    # Paths
    RECORD_DIR="$HOME/recordings"
    CURRENT_RECORD="$RECORD_DIR/current_record.wav"

    # Create the recording directory if it doesn't exist
    mkdir -p "$RECORD_DIR"

    # Toggle recording state
    if pgrep -f "arecord" > /dev/null; then
        # Stop recording
        pkill -f arecord
        sleep 1  # Wait for 1 second to ensure the file is fully written
        hyprctl notify -1 3000 "rgb(ffffff)" "fontsize:35 Stopped recording"

        # Check if the recording file exists and is not empty
        if [[ -f "$CURRENT_RECORD" && -s "$CURRENT_RECORD" ]]; then
            # Send the WAV file to the server
            MAX_RETRIES=3
            RETRY_DELAY=1
            RESPONSE="null"

            for i in $(seq 1 $MAX_RETRIES); do
                RESPONSE=$(curl -s -X POST -F "file=@$CURRENT_RECORD" http://192.168.101.15:5000/transcribe)
                if [[ "$RESPONSE" != "null" ]]; then
                    break
                fi
                sleep $RETRY_DELAY
            done

            # Extract the transcription from the server response
            TRANSCRIPTION=$(echo "$RESPONSE" | jq -r '.text')

            # Input or copy the text
            if command -v wtype &>/dev/null; then
                # Input text using wtype
                wtype "$TRANSCRIPTION"
            else
                # Fallback: copy text to clipboard
                echo -n "$TRANSCRIPTION" | wl-copy
            fi
        else
            hyprctl notify -1 3000 "rgb(ff0000)" "fontsize:35 Recording file is empty or missing"
        fi
    else
        # Start recording
        hyprctl notify -1 888 "rgb(ffffff)" "fontsize:35 Started recording"
        arecord -f cd -t wav "$CURRENT_RECORD"
    fi
  '';
  toggleWorkspaceScript = ''
    #!/usr/bin/env bash

    # Get the current workspace ID
    current_workspace=$(hyprctl activeworkspace | grep -oP 'workspace ID \K\d+')

    # Toggle between workspace 4 and 5
    if [ "$current_workspace" == "5" ]; then
        hyprctl dispatch workspace 4
    elif [ "$current_workspace" == "4" ]; then
        hyprctl dispatch workspace 5
    else
        # If not in workspace 4 or 5, jump to workspace 4 by default
        hyprctl dispatch workspace 4
    fi
  '';

  mcdir = ''
    #!/usr/env/bin/ bash
    if [ -z "$1" ]; then
        echo "Usage: mcdir <directory_name>"
        return 1
    fi

    mkdir -p "$1" && cd "$1"
  '';

  rcdir = ''
    #!/usr/bin/env bash
    while true; do
        # Prompt user for confirmation
        read -p "Do you want to continue? [y/N] " confirm

        # Convert to lowercase for case-insensitivity
        confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

        case $confirm in
            y)
                rm -rf "$(pwd)"
                cd ..
                return 0
                ;;
            ""|n)
                return 1
                ;;
            *)
                echo "Invalid input. Please enter 'y' or 'n'."
                ;;
        esac
      done
  '';
  startPomodoro = ''
    #!/usr/bin/env bash
        # Pomodoro Timer with Time-Based Notifications and Network Control

        # Function to calculate time difference in seconds
        time_diff() {
            local target_time="$1"
            local current_time=$(date +%H:%M:%S)
            local target_seconds=$(date -d "$target_time" +%s)
            local current_seconds=$(date -d "$current_time" +%s)
            echo $((target_seconds - current_seconds))
        }

        # Main loop
        while true; do
            # Start 30-minute work
            # aplay ~/.config/hypr/ding.wav &
            # 5-minute break timer
            hyprshade on black
            # hyprctl notify -1 3000 "rgb(ffffff)" "fontsize:35 Break for 5 minutes!"
            # aplay ~/.config/hypr/ding.wav &
            sleep 300  # 5 minutes (300 seconds)

            # Get current time and calculate time difference to 21:00
            current_time=$(date +%H:%M:%S)
            target_time_21="21:00:00"
            target_time_23="23:00:00"
            diff_to_21=$(time_diff "$target_time_21")
            diff_to_23=$(time_diff "$target_time_23")
            hyprshade off
            # Check if current time is before 21:00
            if [ "$diff_to_21" -gt 0 ]; then
                # If time gap to 21:00 is less than one hour (3600 seconds)
                if [ "$diff_to_21" -lt 3600 ]; then
                    # Notify the time gap to 21:00
                    minutes_left=$((diff_to_21 / 60))
                    hyprctl notify -1 5000 "rgb(ffffff)" "fontsize:35 Break time over! Start to Flow for 30 minutes. $minutes_left minutes left until 21:00."
                else
                    # Notify normally
                    hyprctl notify -1 5000 "rgb(ffffff)" "fontsize:35 Break time over! Start to Flow for 30 minutes."
                fi
            else
                # If current time is past 21:00
                if [ "$diff_to_23" -gt 0 ]; then
                    # Turn off network
                    nmcli networking off
                    # Notify network is off and time gap to 23:00
                    minutes_left=$((diff_to_23 / 60))
                    hyprctl notify -1 7000 "rgb(ffffff)" "fontsize:35 Network turned off. $minutes_left minutes left until 23:00."
                else
                    # If current time is past 23:00, do nothing
                    hyprctl notify -1 15000 "rgb(ffffff)" "fontsize:35 It's past 23:00, time to sleep, For Long Tomorrow!"
                fi
            fi
            sleep 1790  # 30 minutes (1800 seconds)
            hyprctl notify -1 10000 "rgb(ffffff)" "fontsize:35 Gonna break, Just take a relax~"
            sleep 10 # 10 seconds (1800 seconds)
        done
  '';
in
  lib.mkIf (userSetting.windowmanager == "hyprland") {
    # services.dunst = {
    #   enable = true;
    # };

    home.packages = with pkgs; [
      cliphist
      dunst
      # inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      grimblast
      (writeShellScriptBin "toggle-workspace" toggleWorkspaceScript) # Create the script as a bin
      (writeShellScriptBin "start-pomodoro" startPomodoro) # Create the script as a bin
      (writeShellScriptBin "sendspeech" toggleSpeechtotextScript) # Create the script as a bin
      (writeShellScriptBin "mcdir" mcdir) # Create the script as a bin
      (writeShellScriptBin "rcdir" rcdir) # Create the script as a bin
      hyprshade
      hyprpicker
      hyprpolkitagent
      # rofi-wayland-unwrapped
      wf-recorder
      wl-clipboard
      wlsunset
      hyprshade
      # hyprpaper
      # pkgs.dconf
    ];

    # programs.rofi = {
    #   package = pkgs.rofi-wayland-unwrapped;
    #   enable = true;
    #   theme = ./interstellar.rasi;
    # };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = ".config/hypr/takeabreak.png";
          }
        ];
      };
    };

    home.file.".config/hypr/takeabreak.png".source = ./takeabreak.png;
    home.file.".config/hypr/ding.wav".source = ./ding.wav;
    home.file.".config/hypr/shaders/blue.glsl".source = ./blue.glsl;
    home.file.".config/hypr/shaders/black.glsl".source = ./black.glsl;
    home.file.".config/hypr/shaders/invert.glsl".source = ./invert.glsl;

    wayland.windowManager.hyprland.enable = true;
    # wayland.windowManager.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    wayland.windowManager.hyprland.package = pkgs.hyprland;
    # wayland.windowManager.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_options = "fkeys:basic_13-24";
      };
      bind =
        [
          "$mod, mouse_down, exec, hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 1}')"
          "$mod, mouse_up, exec, hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 1}')"
          "$mod, A, exec, alacritty"
          # "$mod ALT, H, exec, hyprshade toggle"
          "$mod ALT, I, exec, hyprshade toggle invert"
          "$mod SHIFT, V, exec, cliphist list | head -n 2 | tail -n 1 | cliphist decode | wl-copy & wl-paste"
          # "$mod ALT, B, exec, hyprshade toggle blue"
          "$mod, B, exec, firefox-beta"
          "$mod ALT, E, exec, emacsclient -c -a 'emacs'"
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

          "$mod, C, killactive"
          "$mod, down, movefocus, d"
          "$mod, D, exec,paperlike-cli -i2c /dev/i2c-4 -clear "
          "$mod, F, togglefloating"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          "$mod, N, movefocus, l"
          "$mod, O, movefocus, r"
          "$mod, E, movefocus, d"
          "$mod, I, movefocus, u"
          "$mod, P, exec, hyprlock"
          "$mod, U, fullscreen"
          "$mod, U, cyclenext"
          # "$mod, J, cyclenext"
          # "$mod, J, bringactivetotop"
          "$mod SHIFT, R, workspace,previous"
          "$mod, R, exec, toggle-workspace"
          "$mod, Q, exec, sendspeech"
          "$mod  SHIFT ALT, Q, exit"
          "$mod, S, fullscreen"
          "$mod  SHIFT, H, exec, systemctl hybrid-sleep"
          "$mod, X, fullscreenstate, 0 2"
          "$mod  SHIFT, P, pin"
          "$mod, T, togglesplit"
          "$mod, up, movefocus, u"
          "$mod, V, exec, cliphist list | rofi -dmenu| cliphist decode | wl-copy"
          "$mod SHIFT, D, exec, cliphist list | rofi -dmenu| cliphist delete"
          "$mod, W, exec, rofi -show drun"
          ", Print, exec, grimblast copy area"
          "SHIFT, Print, exec, grimblast copysave"

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
          ++ # Generate binds for $mod+ALT+1 to $mod+ALT+9
          builtins.concatLists (builtins.genList (x: let
              key = x + 1;
            in [
              "$mod ALT, ${
                toString key
              }, exec, paperlike-cli -i2c /dev/i2c-4 -contrast ${toString key}"
            ])
            9)
          ++ builtins.concatLists (builtins.genList (x: let
              key = x + 1;
            in [
              "$mod CTRL, ${
                toString key
              }, exec, paperlike-cli -i2c /dev/i2c-4 -mode ${toString key}"
            ])
            4)
          ++ builtins.concatLists (builtins.genList (x: let
              key = x + 5;
              key1 = x + 1;
            in [
              "$mod CTRL, ${
                toString key
              }, exec, paperlike-cli -i2c /dev/i2c-4 -speed ${toString key1}"
            ])
            5)
        );

      xwayland = {force_zero_scaling = true;};
      exec-once = [
        # "wlsunset -l 29.5 -L 106.5"
        #"wpaperd"
        # "start-pomodoro"
        "dunst"
        # "hyprpaper"
        # "cp ~/.config/fcitx5/profile-bak ~/.config/fcitx5/profile"
        "systemctl --user start hyprpolkitagent"
        # "systemctl --user start xremap"
        "wl-paste --type text --watch cliphist store"
        # "fcitx5 -d --replace"
        # "fcitx5-remote -r"
        "hyprctl dispatch workspace 5"
        # "firefox-beta"
        "emacsclient -c -a 'emacs'"
        # "ags"
      ];

      "debug:disable_scale_checks" = true;
      env = [
        "GDK_BACKEND, wayland,x11"
        "QT_QPA_PLATFORM, wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "CLUTTER_BACKEND, wayland"
        "ADW_DISABLE_PORTAL, 1"
        # "GDK_DPI_SCALE,1.5"
        "GDK_SCALE,2"
        "XCURSOR_SIZE,32"

        "GTK_IM_MODULE,"

        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_WEBRENDER,1"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];
      cursor = {inactive_timeout = "1";};
      general = {
        gaps_in = "0";
        gaps_out = "0";
        border_size = "0";
        layout = "dwindle";
      };

      misc = {
        vfr = true;
        disable_autoreload = true;
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
        "size 1000 500, title:^(Save As)(.*)$"
        "float, class:^(QQ)$"
        "float, class:^(kruler)$"
        "float,title:^(查看媒体)$|^(图片查看)$|^(图片查看器)$|^(KDE)$"
        "float, class:^(yuri)$"
        "float, class:^(jetbrains-studio)$"
        "float, class:^(feishu)$"
        "size 75% 75%, class:^(QQ)$"
        "center, class:^(QQ)$"

        "float, title:rofi.*"
        "float,forceinput,immediate,title:^(App)$"
      ];
      decoration = {
        rounding = "0";
        blur = {
          enabled = "false";
        };
        shadow = {
          enabled = "false";
        };
      };
      animations = {
        enabled = false;
        first_launch_animation = false;
      };
      dwindle = {
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };
      gestures = {workspace_swipe = "off";};
      monitor = [
        # ",preferred,0x0,1,transform,0"
        # "DP-1,preferred,0x0,1.2,transform,1"
        ",preferred,auto,2,transform,1"
        # "HDMI-A-1,4096x2160@60,0x0,2.5,transform,0"
      ];
      # workspace = [
      #   "0, monitor:DP-2, default:true"
      #   "9, monitor:DP-2, default:true"
      #   "6, monitor:DP-2, default:true"
      # ];
      "$mod" = "SUPER";
      bindm = ["$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow"];
    };
  }
