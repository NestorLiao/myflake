{
  description = "Randy's NixOS Flake";

  nixConfig = {
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://anyrun.cachix.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
  

  inputs = {
    nur.url = github:nix-community/NUR;
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =inputs@{ nixpkgs, home-manager, nur, anyrun, ...  }: let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system.packages = [ anyrun.packages.${system}.anyrun ];
      modules = [
        ./configuration.nix
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            # inherit inputs;
            inherit anyrun;
          };
          home-manager.users.randy= {
            imports=[
              anyrun.homeManagerModules.default
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}
