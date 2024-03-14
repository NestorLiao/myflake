{
  pkgs,
  inputs,
  lib,
  userSetting,
  ...
}: {
  services.xserver.enable = true;

  services.xserver.desktopManager.plasma6.enable = lib.mkIf (userSetting.windowmanager == "plasma") true;
  services.xserver.displayManager.sddm.enable = lib.mkIf (userSetting.windowmanager == "plasma") true;

  services.greetd = lib.mkIf (userSetting.windowmanager == "hyprland") {
    enable = true;
    settings = {
      default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      # Autologin
      initial_session = {
        command = "Hyprland";
        user = userSetting.username;
      };
    };
  };

  programs.hyprland = lib.mkIf (userSetting.windowmanager == "hyprland") {
    enable = true;
    xwayland = {enable = true;};
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
