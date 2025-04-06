{
  pkgs,
  inputs,
  lib,
  userSetting,
  ...
}:{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager = {
      gnome.enable = (userSetting.windowmanager == "gnome");
    };
    displayManager = {
      gdm.enable = (userSetting.windowmanager == "gnome");
    };
  };

  services.displayManager.sddm.enable = (userSetting.windowmanager == "plasma");
  services.desktopManager.plasma6.enable= (userSetting.windowmanager == "plasma");

  services.greetd = lib.mkIf (userSetting.windowmanager == "sway") {
    enable = true;
    settings = {
      default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${userSetting.windowmanager} --theme 'text=black;container=white;prompt=black;input=black;border=black;title=black;greet=black;action=black;button=black;time=black'";
      # Autologin
      initial_session = {
        command = userSetting.windowmanager;
        user = userSetting.username;
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    colors = [
      "FFFFFF" # Black → Off-White (Background)
      "202124" # Red → Dark Gray (Text)
      "252525" # Green → Dark Gray
      "303030" # Yellow → Darker Gray
      "3A3A3A" # Blue → Even Darker Gray
      "444444" # Magenta → Almost Black
      "4E4E4E" # Cyan → Blackish Gray
      "555555" # White → Soft Black
      "E0E0E0" # Bright Black → Light Gray
      "A94442" # Bright Red → Muted Red
      "3A7D44" # Bright Green → Darker Green
      "B58332" # Bright Yellow → Muted Gold
      "2955A3" # Bright Blue → Muted Blue
      "8650A3" # Bright Magenta → Muted Purple
      "31718C" # Bright Cyan → Muted Teal
      "2A2A2A" # Bright White → Almost Black
    ];
  };

}
