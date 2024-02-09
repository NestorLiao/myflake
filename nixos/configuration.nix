# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example
    # inputs.hosts.nixosModule.networking

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager

    # Import modules
    ./modules

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # inputs.xremap-flake.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    # useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      # Import your home-manager configuration
      randy = import ../home-manager/laptop/randy.nix;
      nestor = import ../home-manager/laptop/nestor.nix;
      server = import ../home-manager/server/server.nix;
    };
  };
  services.xserver.enable = true;
}
