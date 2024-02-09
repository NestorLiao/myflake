{
  pkgs,
  inputs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      # Autologin
      initial_session = {
        command = "Hyprland";
        user = "randy";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland = {enable = true;};
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
