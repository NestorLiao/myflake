# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {

  home.packages = with pkgs; [
    xdragon
    bat
    bacon
    calibre
    cht-sh
    cliphist
    fd
    firefox
    fzf
    gimp
    gitui
    gnome.cheese
    grimblast
    imv
    libreoffice
    manix
    mprocs
    mpv
    neofetch
    nnn
    qq
    ripgrep
    rofi
    swaybg
    thefuck
    tldr
    tmux-sessionizer
    translate-shell
    unzip
    vivaldi
    wf-recorder
    wl-clipboard
    # wpsoffice-cn
    xfce.thunar
    zip
    hyprpicker
  (pkgs.writeScriptBin "ts" ''
    #!/usr/bin/env bash

    # Execute wl-paste and store the output in a variable
    clipboard_content=$(wl-paste)

    # Translate the clipboard content from English to Simplified Chinese using `trans`
    translated_content=$(echo "$clipboard_content" | trans :zh)

    # Remove ANSI escape codes from the translated content using `sed`
    cleaned_content=$(echo "$translated_content" | sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g")

    # Print the final cleaned content
    echo "$cleaned_content"
  '')
   
  ];

  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./modules
  ];

  # nixpkgs = {
  #   # You can add overlays here
  #   overlays = [
  #     # Add overlays your own flake exports (from overlays and pkgs dir):
  #     outputs.overlays.additions
  #     outputs.overlays.modifications
  #     outputs.overlays.unstable-packages

  #     # You can also add overlays exported from other flakes:
  #     # neovim-nightly-overlay.overlays.default

  #     # Or define it inline, for example:
  #     # (final: prev: {
  #     #   hi = final.hello.overrideAttrs (oldAttrs: {
  #     #     patches = [ ./change-hello-to-hi.patch ];
  #     #   });
  #     # })
  #   ];
  #   # Configure your nixpkgs instance
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #     # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #     allowUnfreePredicate = (_: true);
  #   };
  # };

  # TODO: Set your username
  home = {
    username = "randy";
    homeDirectory = "/home/randy";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

}
