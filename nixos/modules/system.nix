#
# system.nix
#
# Configure the system
#
{
  pkgs,
  config,
  ...
}: {
  # https://github.com/ghostbuster91/blogposts/blob/main/router2023-part2/main.md

  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.extraModprobeConfig = ''
    options usbcore use_both_schemes=yes
  '';

  boot.resumeDevice = "/dev/disk/by-uuid/c2af3dda-2417-4ed6-b4c2-eeab011a8e34";
  boot.kernelParams = ["resume_offset=22816000"];

  boot = {
    kernel = {
      sysctl = {
        # forward network packets that are not destined for the interface on which they were received
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
        "net.ipv4.conf.br-lan.rp_filter" = 1;
        "net.ipv4.conf.wan.rp_filter" = 1;
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages;
  # Bootloader
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    # offload = {
    # 	enable = true;
    # 	enableOffloadCmd = true;
    # };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];

    # xdg-desktop-portal-hyprland
    # xdg-desktop-portal
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-wlr
    # xdg-desktop-portal-gnome
  };

  # services.xserver.libinput.enable = true;
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  time.timeZone = "Asia/Shanghai";
  services.udisks2.mountOnMedia = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  hardware.pulseaudio.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
