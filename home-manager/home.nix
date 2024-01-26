# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  username = "randy";
in {
  home.packages = with pkgs; [
    discord
    arduino-ide
    hugo
    blender
    calibre
    gimp
    gnome.cheese
    kicad
    libreoffice
    mpv
    qq
    vivaldi
    wpsoffice
    xfce.thunar
    zip
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

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "randy";
    homeDirectory = "/home/randy";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  programs.firefox = {
    enable = true;
    profiles.${username} = {
      userChrome = ''
         /* hides the title bar */
         #titlebar {
           visibility: collapse;
         }


        #nav-bar {
          /* customize this value. */
          --navbar-margin: -38px;

          margin-top: var(--navbar-margin);
          margin-bottom: 0;
          z-index: -100;
          transition: all 0.3s ease !important;
          opacity: 0;
        }

        #navigator-toolbox:focus-within > #nav-bar,
        #navigator-toolbox:hover > #nav-bar
        {
          margin-top: 0;
          margin-bottom: var(--navbar-margin);
          z-index: 100;
          opacity: 1;
        }


      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.display.os-zoom-behavior" = 0;
      };
    };
  };

  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
