# system.nix
#
# Configure the system
#
{ lib, pkgs, config, inputs, ... }:
let
  # ch341 = pkgs.callPackage ./ch341_kmod.nix {
  #   kernel = config.boot.kernelPackages.kernel;
  # };
in {
  # https://github.com/ghostbuster91/blogposts/blob/main/router2023-part2/main.md
  boot.kernelModules = [ "i2c-dev" "i915" "spi-ch341" ];

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

  services.xserver.videoDrivers = [ "modesetting" ];

  # Forces a reset for specified bluetooth usb dongle.
  systemd.services.fix-generic-usb-bluetooth-dongle = {
    description = "Fixes for generic USB bluetooth dongle.";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    script = builtins.readFile ./reset.sh;
    scriptArgs = "0a12:0001"; # Vendor ID and Product ID here
    serviceConfig.Type = "oneshot";
  };

  boot.loader.grub.theme="${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";

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

  time.timeZone = "Asia/Shanghai";
  services.udisks2.mountOnMedia = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;

  programs.bash.undistractMe.playSound = true;

  programs.soundmodem.enable = true;

  xdg.sounds.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  programs.nano.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = false;
    wireplumber.enable = true;
  };

  services.power-profiles-daemon.enable = false;

  environment.etc = {
    "wireplumber/main.lua.d/90-suspend-timeout.lua".text = ''
      apply_properties = {
        ["session.suspend-timeout-seconds"] = 0;
                         };
    '';
  };

  boot.extraModprobeConfig = ''
    options snd-hda-intel power_save=0 power_save_controller=N
  '';
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
