#
# system.nix
#
# Configure the system
#
{
  pkgs,
  config,
  inputs,
  ...
}: {
  # https://github.com/ghostbuster91/blogposts/blob/main/router2023-part2/main.md
  boot.kernelModules = ["i2c-dev" "i915"];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  # boot.extraModprobeConfig = ''
  #   options usbcore use_both_schemes=yes
  # '';

  # boot.resumeDevice = "/swap/swapfile";
  # boot.resumeDevice = "/dev/disk/by-uuid/c2af3dda-2417-4ed6-b4c2-eeab011a8e34";
  # boot.kernelParams = ["resume_offset=27270400"];
  # boot.kernelParams = ["resume_offset=22816000"];

  # boot.binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" "i686-linux"];

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

  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages;

  # Bootloader
  boot.loader.timeout = 3;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # hardware.bluetooth.package = pkgs.bluez;
  # hardware.bluetooth.enable = false;
  # hardware.bluetooth.powerOnBoot = false;

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  # services.xserver.videoDrivers = ["nvidia"];
  services.xserver.videoDrivers = ["modesetting"];
  # Please remove "intel" from `services.xserver.videoDrivers` and switch to the "modesetting" driver.
  # services.asusd.enable = true;
  # services.asusd.enableUserService = true;

  hardware = {
    # always enable bluetooth
    bluetooth.enable = true;

    # always enable graphics drivers and enable a bunch of layers for it (including vulkan validation)
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel # video acceleration on intel inbuilt graphics
        vulkan-validation-layers # helps catch and debug vulkan crashes
      ];
    };
  };
  hardware.enableAllFirmware = true; # enable all firmware regardless of license

  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };

  # hardware.nvidia.prime = {
  #   sync.enable = true;
  #   # offload = {
  #   #   enable = true;
  #   #   enableOffloadCmd = true;
  #   # };
  #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   xdgOpenUsePortal = true;
  #   extraPortals = [
  #     # pkgs.xdg-desktop-portal-hyprland
  #     # inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
  #     # pkgs.xdg-desktop-portal-gtk
  #   ];
  # };

  # services.libinput.enable = true;

  # security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  time.timeZone = "Asia/Shanghai";
  services.udisks2.mountOnMedia = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;

  hardware.pulseaudio.enable = false;

  # hardware.keyboard.qmk.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
