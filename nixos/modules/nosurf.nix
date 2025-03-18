{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.nosurf;
in
  with lib; {
    options = {
      services.nosurf = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Enable automatic internet disconnection from 8 PM to 2 PM.";
        };
      };
    };

    config = mkIf cfg.enable {
      # Define the systemd service for disconnecting the internet at 8 PM
      systemd.services.internetDisconnect = {
        wantedBy = ["timers.target"];
        after = ["network.target"];
        description = "Disconnect internet from 8 PM to 2 PM.";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.networkmanager}/bin/nmcli networking off";
        };
      };

      # Define the systemd service for reconnecting the internet at 2 PM
      systemd.services.internetReconnect = {
        wantedBy = ["timers.target"];
        after = ["network.target"];
        description = "Reconnect internet after 2 PM.";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.networkmanager}/bin/nmcli networking on";
        };
      };

      # Define the timers with proper syntax
      systemd.timers.internetDisconnectTimer = {
        unitConfig = {
          description = "Timer to disconnect internet at 8 PM";
          wantedBy = ["timers.target"];
        };
        timerConfig = {
          OnCalendar = "*-*-* 21:00:00"; # Set the timer for 8 PM
        };
        wants = ["internetDisconnect.service"];
      };

      systemd.timers.internetReconnectTimer = {
        unitConfig = {
          description = "Timer to reconnect internet at 2 PM";
          wantedBy = ["timers.target"];
        };
        timerConfig = {
          OnCalendar = "*-*-* 14:00:00"; # Set the timer for 2 PM
        };
        wants = ["internetReconnect.service"];
      };
    };
  }
