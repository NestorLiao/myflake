#
# system.nix
#
# Configure the system
#
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  # ch341 = pkgs.callPackage ./ch341_kmod.nix {
  #   kernel = config.boot.kernelPackages.kernel;
  # };
in {
  # https://github.com/ghostbuster91/blogposts/blob/main/router2023-part2/main.md
  boot.kernelModules = ["i2c-dev" "i915" "spi-ch341"];

  boot.extraModulePackages = [
    # ch341
  ];

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
  # boot.kernelPackages = pkgs.linuxPackages_6_11;

  # Bootloader
  boot.loader.timeout = 3;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

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

  # Forces a reset for specified bluetooth usb dongle.
  systemd.services.fix-generic-usb-bluetooth-dongle = {
    description = "Fixes for generic USB bluetooth dongle.";
    wantedBy = ["post-resume.target"];
    after = ["post-resume.target"];
    script = builtins.readFile ./reset.sh;
    scriptArgs = "0a12:0001"; # Vendor ID and Product ID here
    serviceConfig.Type = "oneshot";
  };

  hardware = {
    # always enable bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

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

  time.timeZone = "Asia/Shanghai";
  services.udisks2.mountOnMedia = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;

  programs.bash.undistractMe.playSound = false;

  programs.soundmodem.enable = false;

  xdg.sounds.enable = false;

  services.jack.alsa.support32Bit = false;

  hardware.pulseaudio.enable = false;

  programs.nano.enable = false;

  services.pipewire = {
    enable = false;
    alsa.enable = false;
    alsa.support32Bit = false;
    pulse.enable = false;
    jack.enable = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
