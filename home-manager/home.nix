{ outputs, userSetting, inputs, lib, pkgs, ... }:
let
in {
  imports = [ ./foot.nix ./clitools.nix ];

  home.file.".local/share/fonts".source = ./theme/fonts;
  home.file.".config/sway/white.jpg".source = ./theme/white.jpg;
  home.file.".config/sway/config".source = ./theme/Swayconfig;
  home.file.".config/sway/takeabreak.png".source = ./theme/takeabreak.png;

  home.packages = with pkgs; [ ];

  home.enableNixpkgsReleaseCheck = false;

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # (final: prev: {
      #   blender = prev.blender.override {cudaSupport = true;};
      # })

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

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 40;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-White";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 16;
    };
  };

  qt = {
    platformTheme.name = "gtk";
    enable = true;
    style.name = "adwaita-highcontrast";
    style.package = pkgs.adwaita-qt6;
  };

  # TODO: Set your username
  home = {
    username = "${userSetting.username}";
    homeDirectory = "/home/${userSetting.username}";
  };

  xdg.mimeApps.enable = true;
  # 不在通常位置生成配置文件
  xdg.configFile."mimeapps.list".enable = false;
  # 允许桌面应用程序修改文件关联
  xdg.dataFile."applications/mimeapps.list".force = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
