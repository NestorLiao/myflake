{
  inputs,
  userSetting,
  pkgs,
  ...
}: {
  imports = [
    inputs.daeuniverse.nixosModules.dae
    inputs.hosts.nixosModule
    {
      networking.stevenBlackHosts = {
        enable = true;
        blockFakenews = true;
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        ###################################### don't fucking play with it
        #  __      __         .__  .__               .__                                                         _____
        # /  \    /  \ ____   |  | |__|__  __ ____   |__| ____   _____    ____   _____     ____   ____     _____/ ____\
        # \   \/\/   // __ \  |  | |  \  \/ // __ \  |  |/    \  \__  \  /    \  \__  \   / ___\_/ __ \   /  _ \   __\
        #  \        /\  ___/  |  |_|  |\   /\  ___/  |  |   |  \  / __ \|   |  \  / __ \_/ /_/  >  ___/  (  <_> )  |
        #   \__/\  /  \___  > |____/__| \_/  \___  > |__|___|  / (____  /___|  / (____  /\___  / \___  >  \____/|__|
        #        \/       \/                     \/          \/       \/     \/       \//_____/      \/
        # .__        _____                            __  .__                                         .__                    .___
        # |__| _____/ ____\___________  _____ _____ _/  |_|__| ____   ____     _______  __ ___________|  |   _________     __| _/
        # |  |/    \   __\/  _ \_  __ \/     \\__  \\   __\  |/  _ \ /    \   /  _ \  \/ // __ \_  __ \  |  /  _ \__  \   / __ |
        # |  |   |  \  | (  <_> )  | \/  Y Y  \/ __ \|  | |  (  <_> )   |  \ (  <_> )   /\  ___/|  | \/  |_(  <_> ) __ \_/ /_/ |
        # |__|___|  /__|  \____/|__|  |__|_|  (____  /__| |__|\____/|___|  /  \____/ \_/  \___  >__|  |____/\____(____  /\____ |
        #         \/                        \/     \/                    \/                   \/                      \/      \/
        ####################################################################################################
        blockGambling = true;
        blockPorn = true;
        blockSocial = false;
      };
    }
  ];

  services.v2raya.enable = false;
  # with dae
  services.dae = {
    enable = true;
    disableTxChecksumIpGeneric = false;
    configFile = "/etc/dae/config.dae";
    assets = with pkgs; [v2ray-geoip v2ray-domain-list-community];
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  networking = {
    firewall = {
      enable = true;
      # allowedTCPPorts = [5000];
      # allowedUDPPorts = [];
      # extraCommands = ''
      #   iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
      # '';
    };
    hostName = userSetting.hostname;
    networkmanager.enable = true;
  };

  services.create_ap.enable = false;
  services.create_ap.settings = {
    INTERNET_IFACE = "enp46s0";
    PASSPHRASE = "12345678";
    SSID = "My Wife Hotspot";
    WIFI_IFACE = "wlp45s0";
  };

  services.dnsmasq = {
    enable = true;
    # resolve local queries (add 127.0.0.1 to /etc/resolv.conf)
    resolveLocalQueries = false; # may be conflict with dae, disable this.
    alwaysKeepRunning = true;
    # https://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=tree
    settings = {
      # upstream DNS servers
      server = [
        "119.29.29.29" # DNSPod
        "223.5.5.5" # AliDNS
        "8.8.4.4"
        # "1.1.1.1"
      ];
      # forces dnsmasq to try each query with each server strictly
      # in the order they appear in the config.
      strict-order = true;
      # Never forward plain names (without a dot or domain part)
      domain-needed = true;
      # Never forward addresses in the non-routed address spaces(e.g. private IP).
      bogus-priv = true;
      # don't needlessly read /etc/resolv.conf which only contains the localhost addresses of dnsmasq itself.
      no-resolv = true;
      # Cache dns queries.
      cache-size = 1000;
    };
  };

  # The service irqbalance is useful as it assigns certain IRQ calls to specific CPUs instead of
  # letting the first CPU core to handle everything.
  # This is supposed to increase performance by hitting CPU cache more often.
  services.irqbalance.enable = false;
}
