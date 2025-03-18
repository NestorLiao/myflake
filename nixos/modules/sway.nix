{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
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

    # Get the current workspace name (assumes workspace names are "4" and "5")
    current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

    # Toggle between workspace "4" and "5"
    if [ "$current_workspace" = "5" ]; then
        swaymsg workspace number 4
    elif [ "$current_workspace" = "4" ]; then
        swaymsg workspace number 5
    else
        # If not in workspace "4" or "5", jump to workspace "4" by default
        swaymsg workspace number 4
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
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    # wmenu
    fuzzel
    cliphist
    wtype
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.satty)
    wl-gammarelay-rs
    wf-recorder
    libnotify
    woomer
    (writeShellScriptBin "toggle-workspace" toggleWorkspaceScript) # Create the script as a bin
    (writeShellScriptBin "start-pomodoro" startPomodoro) # Create the script as a bin
    (writeShellScriptBin "sendspeech" toggleSpeechtotextScript) # Create the script as a bin
    (writeShellScriptBin "mcdir" mcdir) # Create the script as a bin
    (writeShellScriptBin "rcdir" rcdir) # Create the script as a bin
  ];

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable sway window manager
  programs.sway = {
    package = pkgs.unstable.sway;
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
