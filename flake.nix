{
  description = "My Config";

  nixConfig = {
    builders-use-substitutes = true;
    experimental-features = ["nix-command" "flakes"];
    extra-trusted-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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
      username = "leeao";
      hostname = "nixos";
      email = "gtkndcbfhr@gmail.com";
      windowmanager = "sway";
    };
  in {
    nixosConfigurations = {
      ${userSetting.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs userSetting;};
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./nixos/modules
          ./nixos/hardware-configuration.nix
        ];
      };
    };

    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    overlays = import ./overlays/default.nix {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
  };

  inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/42a1c966be226125b48c384171c44c651c236c22";

    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts.url = "github:StevenBlack/hosts";
  };
}
