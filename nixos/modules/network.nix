{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.daeuniverse.nixosModules.dae
  ];

  services.v2raya.enable = true;
  # systemd.network.networks.randy.dns = [  185.199.108.133 ];

  # with dae
  services.dae = {
    enable = true;
    # configFile = ./bypass-router.dae;
    configFile = "/home/nestor/nink/retain/config.dae";
    # configFile = "/etc/dae/config.dae";
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };
}
