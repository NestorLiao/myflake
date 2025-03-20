{
  config,
  pkgs,
  lib,
  userSetting,
  ...
}: {
  # Always include common imports
  imports = [
    ./udev.nix # Cable drives
    ./hosts.nix
    ./inputfonts.nix # Fcitx input method and fonts
    ./enviroment.nix # Environment packages and variables
    ./nix-ld.nix # nix-ld CLI tool
    ./fish.nix # Fish shell
    ./display.nix # Display config
    ./network.nix # Network configuration
    ./pkgs.nix # Custom packages
    ./ssh.nix # SSH configuration
    ./system.nix # System settings
    ./users.nix # User settings
    (
      if userSetting.windowmanager == "sway"
      then ./sway.nix
      else ./users.nix
    ) # Conditionally add sway.nix if window manager is "sway"
  ];
}
