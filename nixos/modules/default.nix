{
  config,
  pkgs,
  lib,
  userSetting,
  ...
}: {
  imports = [
    ./udev.nix
    ./hosts.nix
    ./inputfonts.nix
    ./enviroment.nix
    ./nix-ld.nix
    ./fish.nix
    ./display.nix
    ./network.nix
    ./pkgs.nix
    ./ssh.nix
    ./system.nix
    ./users.nix
    (
      if userSetting.windowmanager == "sway"
      then ./sway.nix
      else ./users.nix
    )
  ];
}
