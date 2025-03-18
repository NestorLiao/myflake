{
  pkgs,
  inputs,
  lib,
  userSetting,
  ...
}: {
  services.xserver.enable = true;
  # services.xserver.windowManager.exwm.enable=true;

  services.xserver.desktopManager.gnome.enable = lib.mkIf (userSetting.windowmanager == "gnome") true;
  services.xserver.displayManager.gdm.enable = lib.mkIf (userSetting.windowmanager == "gnome") true;

  services.displayManager.sddm.enable = lib.mkIf (userSetting.windowmanager == "plasma") true;
  services.desktopManager.plasma6.enable = lib.mkIf (userSetting.windowmanager == "plasma") true;

  services.greetd = lib.mkIf (userSetting.windowmanager == "hyprland" || userSetting.windowmanager == "sway") {
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

  programs.hyprland = lib.mkIf (userSetting.windowmanager == "hyprland") {
    enable = true;
    xwayland = {enable = true;};
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    package = pkgs.hyprland;
    # portalPackage = pkgs.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  console.colors = [
    "ffffff" # Black → Pure White (Background)
    "000000" # Red → Pure Black (Text)
    "000000" # Green → Pure Black
    "000000" # Yellow → Pure Black
    "000000" # Blue → Pure Black
    "000000" # Magenta → Pure Black
    "000000" # Cyan → Pure Black
    "000000" # White → Pure Black
    "ffffff" # Bright Black → Pure White
    "000000" # Bright Red → Pure Black
    "000000" # Bright Green → Pure Black
    "000000" # Bright Yellow → Pure Black
    "000000" # Bright Blue → Pure Black
    "000000" # Bright Magenta → Pure Black
    "000000" # Bright Cyan → Pure Black
    "000000" # Bright White → Pure Black
  ];
}
