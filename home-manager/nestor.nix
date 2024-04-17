# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  userSetting,
  inputs,
  pkgs,
  ...
}: {
  # virtualisation.waydroid.enable = true;
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      # dracula-theme.theme-dracula
      # vscodevim.vim
      # yzhang.markdown-all-in-one
      # rust-lang.rust-analyzer
      # llvm-vs-code-extensions.vscode-clangd
    ];
  };

  home.packages = with pkgs; [
    # (octaveFull.withPackages (opkgs: with opkgs; [symbolic]))
    # verilator
    # steam
    wpsoffice-cn
    # telegram-desktop
    stm32cubemx
    logisim-evolution
    # libsForQt5.kdenlive
    android-studio
    android-tools
    # arduino-ide
    # hugo
    mpv
    blender
    # calibre
    # gimp
    # gnome.cheese
    # kicad
    # libreoffice
    qq
    # vivaldi
  ];

  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./default.nix
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
      (final: prev: {
        blender = prev.blender.override {cudaSupport = true;};
      })

      # Helix bleeding edge
      # (
      #   self: super: {
      #     helix = inputs.helix.packages.${self.system}.default;
      #   }
      # )

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
    username = "${userSetting.username}";
    homeDirectory = "/home/${userSetting.username}";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
