{ pkgs, ... }:
let
  timer = ''
    #!/usr/bin/env bash
    # ./time.sh 1 "2025-04-12 16:00:00"
    # to not jerk off!
    # ./time.sh 0 "2025-06-12 16:00:00"
    # to not be fuck loser!!
    CURRENT_TIMESTAMP=$(date +%s)

    MODE="$1"

    case "$MODE" in
    "" )
        echo "无参数，你应该使用 0/1 + time"
        ;;
    0 )
        TARGET_DATE="$2";
        TARGET_TIMESTAMP=$(date -d "$TARGET_DATE" +%s)
        while [ "$CURRENT_TIMESTAMP" -lt "$TARGET_TIMESTAMP" ]; do
            CURRENT_TIMESTAMP=$(date +%s)
            REMAINING=$((CURRENT_TARGET - TIMESTAMP_TIMESTAMP))

            DAYS=$((REMAINING / 86400))
            HOURS=$(((REMAINING % 86400) / 3600))
            MINUTES=$(((REMAINING % 3600) / 60))
            SECONDS=$((REMAINING % 60))

            printf "\rCountdown: %d days, %02d:%02d:%02d remaining" "$DAYS" "$HOURS" "$MINUTES" "$SECONDS"
            sleep 1
        done

        echo -e "\nTime's up!"
        ;;
    1 )
        TARGET_DATE="$2";
        TARGET_TIMESTAMP=$(date -d "$TARGET_DATE" +%s)
        while [ "$CURRENT_TIMESTAMP" -gt "$TARGET_TIMESTAMP" ]; do
            CURRENT_TIMESTAMP=$(date +%s)
            REMAINING=$((CURRENT_TIMESTAMP - TARGET_TIMESTAMP))

            DAYS=$((REMAINING / 86400))
            HOURS=$(((REMAINING % 86400) / 3600))
            MINUTES=$(((REMAINING % 3600) / 60))
            SECONDS=$((REMAINING % 60))

            printf "\rCount: %d days, %02d:%02d:%02d remaining" "$DAYS" "$HOURS" "$MINUTES" "$SECONDS"
            sleep 1
        done

        echo -e "\nTime's is upcomming!"
        ;;
    * )
        echo "未知参数：$MODE，退出"
        exit 1
        ;;
    esac

  '';

  myterm = ''
    #!/usr/bin/env bash

    if swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .name' | grep -q 'Emacs';then
        if swaymsg -t get_tree | jq -e '.. | select(.focused? == true and .fullscreen_mode == 1)' >/dev/null; then
            wtype -M ctrl n -m ctrl  -M ctrl . -m ctrl
            sleep 0.1
        else
            swaymsg fullscreen
            sleep 0.2
            wtype -M ctrl n -m ctrl  -M ctrl . -m ctrl
            sleep 0.1
        fi
    else
        if swaymsg -t get_tree | jq -e '.. | select(.focused? == true and .fullscreen_mode == 1)' >/dev/null; then
            swaymsg '[title=".*Emacs.*"] focus'
            sleep 0.2
            wtype -M ctrl n -m ctrl  -M ctrl . -m ctrl
            sleep 0.1
            swaymsg fullscreen
        else
            swaymsg '[title=".*Emacs.*"] focus'
            sleep 0.2
            wtype -M ctrl n -m ctrl  -M ctrl . -m ctrl
            sleep 0.1
            swaymsg fullscreen
        fi
    fi

  '';
  switchframeup = ''
    #!/usr/bin/env bash

    # Check if focused window is in fullscreen mode
    if swaymsg -t get_tree | jq -e '.. | select(.focused? == true and .fullscreen_mode == 1)' >/dev/null; then
        # If in fullscreen: exit fullscreen, focus down, then re-enter fullscreen
        swaymsg fullscreen
        swaymsg focus up
        swaymsg fullscreen
    else
        # If not in fullscreen: simply focus down
        swaymsg focus up
    fi
  '';
  togglemonitor = ''
    #!/usr/bin/env bash

    STATE_FILE="$HOME/.paperlike_state"

    # Read current state or default to "watch"
    if [ -f "$STATE_FILE" ]; then
        CURRENT_STATE=$(cat "$STATE_FILE")
    else
        CURRENT_STATE="watch"
    fi

    if [ "$CURRENT_STATE" == "watch" ]; then
        echo "Switching to reading mode"
        echo "read" > "$STATE_FILE"
        paperlike-cli -i2c /dev/i2c-4 -contrast 9
        sleep 1.5
        paperlike-cli -i2c /dev/i2c-4 -speed 5
        sleep 1.5
        paperlike-cli -i2c /dev/i2c-4 -mode 1
        sleep 2.5
        paperlike-cli -i2c /dev/i2c-4 -clear
    else
        echo "Switching to watching mode"
        echo "watch" > "$STATE_FILE"
        paperlike-cli -i2c /dev/i2c-4 -contrast 1
        sleep 1.5
        paperlike-cli -i2c /dev/i2c-4 -speed 1
        sleep 1.5
        paperlike-cli -i2c /dev/i2c-4 -mode 4
        sleep 2.5
        paperlike-cli -i2c /dev/i2c-4 -clear
    fi
  '';
  onlyemacs = ''
    #!/usr/bin/env bash

    # Workspace 5: Center - emacs with vterm
    swaymsg workspace 5
    sleep 1.0
    paperlike-cli -i2c /dev/i2c-4 -light2 0
    sleep 1.0
    notify-send -t 8888  "人法地，地法天，天法道，道法自然";
    sleep 0.3
    emacsclient -c -a 'emacs' &
    sleep 3.5
    wtype -M alt n -m alt  org-agenda-list -P Return -p Return
    sleep 0.6
    wtype -M ctrl n -m ctrl 1
    sleep 0.3
    swaymsg fullscreen
    sleep 0.5

    wl-paste --type text --watch cliphist store &
    wl-gammarelay-rs &
    # fcitx5 -d --replace &
    # sleep 0.2
  '';

  switchframe = ''
    #!/usr/bin/env bash

    # Check if focused window is in fullscreen mode
    if swaymsg -t get_tree | jq -e '.. | select(.focused? == true and .fullscreen_mode == 1)' >/dev/null; then
        # If in fullscreen: exit fullscreen, focus down, then re-enter fullscreen
        swaymsg fullscreen
        swaymsg focus down
        swaymsg fullscreen
    else
        # If not in fullscreen: simply focus down
        swaymsg focus down
    fi
  '';
  genemacs = ''
    #!/usr/bin/env bash

    sleep 5.0
    # Workspace 4: Left - eww + gptel
    swaymsg workspace 4
    sleep 1.0
    emacsclient -c -a 'emacs' &
    sleep 5.0
    wtype -M alt n -m alt eww -P Return -p Return -P Return -p Return
    sleep 0.5
    emacsclient -c -a 'emacs' &
    sleep 0.5
    wtype -M alt n -m alt -d 10 "gptel"
    sleep 0.5
    wtype -P Return -p Return -P Return -p Return
    sleep 0.5
    wtype -M ctrl n -m ctrl 1
    sleep 0.5
    swaymsg focus down
    sleep 0.3
    swaymsg fullscreen
    sleep 0.3

    # Workspace 6: Right - Firefox + Foot
    swaymsg workspace 6
    sleep 0.3
    firefox-beta &
    sleep 2.5
    swaymsg workspace 1
    sleep 0.3
    swaymsg move container to workspace number 6
    sleep 0.3
    swaymsg workspace 6
    sleep 0.3
    foot &
    swaymsg workspace 6
    sleep 0.3
    swaymsg focus down
    sleep 0.3
    swaymsg fullscreen
    sleep 0.3

    # Workspace 5: Center - emacs with vterm
    swaymsg workspace 5
    sleep 0.3
    emacsclient -c -a 'emacs' &
    emacsclient -c -a 'emacs' &
    sleep 0.5
    wtype -M ctrl c -m ctrl a -d 100 t
    sleep 0.5
    wtype -M ctrl n -m ctrl 1 -d 10 -k F12
    sleep 0.3
    swaymsg fullscreen

    wl-paste --type text --watch cliphist store &
    wl-gammarelay-rs &
    # fcitx5 -d --replace &
    # sleep 0.2
  '';
  # Define the script content for toggling workspaces
  toggleSpeechtotextScript = ''
    #!/usr/bin/env bash
    # Paths
    RECORD_DIR="$HOME/save/sundry/media/recordings"
    CURRENT_RECORD="$RECORD_DIR/current_record.wav"

    # Create the recording directory if it doesn't exist
    mkdir -p "$RECORD_DIR"

    # Toggle recording state
    if pgrep -f "arecord" > /dev/null; then
        # Stop recording
        pkill -f arecord
        sleep 1  # Ensure the file is fully written
        notify-send -t 3000 "Stopped recording"

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
            TRANSCRIPTION=$(echo "$RESPONSE" | jq -r '.text'| opencc -c t2s)

            # Input or copy the text
            if command -v wtype &>/dev/null; then
                # Input text using wtype
                wtype "$TRANSCRIPTION"
            else
                # Fallback: copy text to clipboard (wl-clipboard should be installed)
                echo -n "$TRANSCRIPTION" | wl-copy
            fi
        else
            notify-send -t 3000 "Recording file is empty or missing"
        fi
    else
        # Start recording
        notify-send -t 888 "Started recording"
        arecord -f cd -t wav "$CURRENT_RECORD"
    fi
  '';
  toggleWorkspaceScript = ''
    #!/usr/bin/env bash

    # Ensure exactly two arguments are provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <workspace1> <workspace2>"
        exit 1
    fi

    workspace1="$1"
    workspace2="$2"

    # Get the current workspace name
    current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

    # Toggle between the provided workspaces
    if [ "$current_workspace" = "$workspace2" ]; then
        swaymsg workspace number "$workspace1"
    elif [ "$current_workspace" = "$workspace1" ]; then
        swaymsg workspace number "$workspace2"
    else
        # If not in either workspace, jump to workspace1 by default
        swaymsg workspace number "$workspace1"
    fi
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

    busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1
    notify-send -t 10000 "Pomodoro Time!" "Let's Get Things Done, Also Have A Good Day! :)"
    sleep 10
    # Main loop
    while true; do
        # 5-minute break timer
        busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 0
        sleep 285  # 5 minutes (300 seconds)
        # paperlike-cli -i2c /dev/i2c-4 -light1 85
        sleep 15
        # paperlike-cli -i2c /dev/i2c-4 -light1 0
        # Get current time and calculate time difference to 21:00 and 23:00
        current_time=$(date +%H:%M:%S)
        target_time_21="21:00:00"
        target_time_23="23:00:00"
        diff_to_21=$(time_diff "$target_time_21")
        diff_to_23=$(time_diff "$target_time_23")

        busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1

        # Check if current time is before 21:00
        if [ "$diff_to_21" -gt 0 ]; then
            # If time gap to 21:00 is less than one hour (3600 seconds)
            if [ "$diff_to_21" -lt 3600 ]; then
                minutes_left=$((diff_to_21 / 60))
                notify-send -t 8888 "Break Over" "Start to flow for 30 minutes. $minutes_left minutes left until 21:00."
            else
                notify-send -t 8888 "Break Over" "Start to flow for 30 minutes."
            fi
        else
            # If current time is past 21:00
            if [ "$diff_to_23" -gt 0 ]; then
                nmcli networking off
                minutes_left=$((diff_to_23 / 60))
                notify-send -t 10000 "Network Off" "Internet disabled. $minutes_left minutes left until 23:00."
            else
                notify-send -t 15000 "Time to Sleep" "It's past 23:00. Rest well for a better tomorrow!"
            fi
        fi

        sleep 1790  # 30 minutes (1800 seconds)
        notify-send -t 10000 "Break Time" "Gonna break, just take a relax~"
        sleep 10  # 10 seconds
    done
  '';
in {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "toggle-workspace" toggleWorkspaceScript)
    (writeShellScriptBin "start-pomodoro" startPomodoro)
    (writeShellScriptBin "sendspeech" toggleSpeechtotextScript)
    (writeShellScriptBin "genemacs" genemacs)
    (writeShellScriptBin "onlyemacs" onlyemacs)
    (writeShellScriptBin "switchframe" switchframe)
    (writeShellScriptBin "switchframeup" switchframeup)
    (writeShellScriptBin "togglemonitor" togglemonitor)
    (writeShellScriptBin "myterm" myterm)
    (writeShellScriptBin "timer" timer)
  ];
}
