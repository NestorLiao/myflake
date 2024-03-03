{
  description = "My new nix config";

  # nix develop --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store  https://cache.nixos.org"

  nixConfig = {
    builders-use-substitutes = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    userSetting = {
      username = "nestor";
      hostname = "nixos";
      email = "gtkndcbfhr@gmail.com";
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      ${userSetting.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs userSetting;};
        modules = [
          # > Our main nixos configuration file <
          # You can import other NixOS modules here
          # If you want to use modules your own flake exports (from modules/nixos):
          # outputs.nixosModules.example
          # inputs.hosts.nixosModule.networking

          # Or modules from other flakes (such as nixos-hardware):
          # inputs.hardware.nixosModules.cixpkgs-unstabommon-cpu-amd
          # inputs.hardware.nixosModules.common-ssd

          # You can also split up your configuration and import pieces of it here:

          # Import home-manager's NixOS module
          inputs.home-manager.nixosModules.home-manager

          # Import modules
          ./nixos/modules

          # Import your generated (nixos-generate-config) hardware configuration
          ./nixos/hardware-configuration.nix
        ];
      };
    };

    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;
  };

  inputs = {
    daeuniverse.url = "github:daeuniverse/flake.nix";
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixOS/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    hyprland.url = "github:hyprwm/Hyprland";
    helix.url = "github:helix-editor/helix";
    xremap-flake.url = "github:xremap/nix-flake";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts.url = "github:StevenBlack/hosts";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };
}
