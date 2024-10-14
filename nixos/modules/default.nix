{
  imports = [
    #ad-blocker
    ./hosts.nix

    #cable drives
    # ./udev.nix

    # searxng service
    # ./searx.nix

    # fcitx input method and fonts
    ./inputfonts.nix

    # nix configuration
    ./nixconf.nix

    # enviroment  package and variable
    ./enviroment.nix

    # nix-ld cli tool
    ./nix-ld.nix

    #fish shell
    ./fish.nix
    ./display.nix

    ./network.nix
    ./pkgs.nix
    ./ssh.nix
    ./system.nix
    ./users.nix
  ];
}
