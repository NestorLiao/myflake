{ config, pkgs, lib, inputs, ... }: {
  environment.systemPackages = with pkgs.unstable; [
    wmenu
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    cliphist
    satty
    wtype
    libnotify
    wl-gammarelay-rs
    wf-recorder
    wl-color-picker
    # woomer
  ];

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable sway window manager
  programs.sway = {
    package = pkgs.unstable.sway;
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
