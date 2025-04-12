{
  inputs,
  userSetting,
  pkgs,
  ...
}: {
  imports = [
    inputs.hosts.nixosModule
    {
      networking.stevenBlackHosts = {
        enable = true;
        blockFakenews = true;
        blockGambling = true;
        blockPorn = true;
        blockSocial = true;
      };
    }
  ];

  # with dae
  services = {
    create_ap = {
      enable = false;
      settings = {
        INTERNET_IFACE = "enp46s0";
        PASSPHRASE = "12345678";
        SSID = "{$userSetting.hostname} Hotspot";
        WIFI_IFACE = "wlp45s0";
      };
    };
    v2raya.enable = false;
    # https://login.ouonetwork.com/login
    dae = {
      package = pkgs.unstable.dae;
      enable = true;
      disableTxChecksumIpGeneric = false;
      configFile = "/home/${userSetting.username}/fun/sundry/config.dae";
      assets = with pkgs.unstable; [v2ray-geoip v2ray-domain-list-community];
      openFirewall = {
        enable = true;
        port = 12345;
      };
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [5000 22];
      allowedUDPPorts = [53];
      # extraCommands = ''
      #   iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
      # '';
    };
    hostName = userSetting.hostname;
    networkmanager.enable = true;
  };

  # letting the first CPU core to handle everything.
  # This is supposed to increase performance by hitting CPU cache more often.
  services.irqbalance.enable = false;
}
