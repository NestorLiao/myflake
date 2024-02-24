{
  inputs,
  userSetting,
  ...
}: {
  imports = [
    inputs.daeuniverse.nixosModules.dae
    inputs.hosts.nixosModule
    {
      networking.stevenBlackHosts = {
        enable = true;
        blockFakenews = true;
        blockGambling = true;
        blockPorn = true;
        blockSocial = false;
      };
    }
  ];
  services.v2raya.enable = true;
  # with dae
  services.dae = {
    enable = true;
    configFile = "/home/${userSetting.username}/nink/retain/config.dae";
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  # networking.firewall.allowedTCPPorts = [8080];
  # networking.firewall.extraCommands = ''
  #   iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
  # '';

  services.create_ap.enable = false;
  services.create_ap.settings = {
    INTERNET_IFACE = "enp46s0";
    PASSPHRASE = "12345678";
    SSID = "My Wifi Hotspot";
    WIFI_IFACE = "wlp45s0";
  };
}
