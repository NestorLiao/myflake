# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-doom-emacs-unstraightened.hmModule
  ];

  # home.file."./.local/share/fcitx5/rime" = {
  #   source = ./rime;
  #   recursive = true;
  # executable = true;
  # };

  # home.packages = with pkgs;
  #   [
  #     fd
  #     curl
  #     sqlite

  #     # for emacs sqlite
  #     gcc
  #     # org mode dot
  #     graphviz
  #     imagemagick

  #     # mpvi required
  #     tesseract5
  #     # ffmpeg_5
  #     ffmpegthumbnailer
  #     mediainfo
  #     # email
  #     # mu4e
  #     # spell check
  #     aspell

  #     # for emacs rime
  #     librime

  #     libwebp
  #     tdlib
  #     fira-code-nerdfont
  #     pkg-config
  #   ]
  #   ++ (lib.optionals pkgs.stdenv.isDarwin) [
  #     # pngpaste for org mode download clip
  #     pngpaste
  #   ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
    # extraConfig = ''
    #   (setq standard-indent 2)
    # '';
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs30; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };

  # programs.pandoc.enable = true;

  # programs.doom-emacs = {
  #   enable = true;
  #   doomDir = ./doom;
  #   extraPackages = epkgs: [epkgs.vterm epkgs.treesit-grammars.with-all-grammars];
  #   provideEmacs = true;
  #   experimentalFetchTree = true;
  # };
  # services.emacs = {
  #   enable = pkgs.stdenv.isLinux;
  #   client.enable = true;
  #   socketActivation.enable = true;
  #   # startWithUserSession = "graphical";
  #   # defaultEditor = true;
  # };
}
