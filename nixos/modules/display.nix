{
  pkgs,
  inputs,
  ...
}: {
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      # Autologin
      initial_session = {
        command = "Hyprland";
        user = "nestor";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland = {enable = true;};
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
