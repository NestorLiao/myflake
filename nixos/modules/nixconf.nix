{
  config,
  lib,
  inputs,
  ...
}: {
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # substituters = ["https://xddxdd.cachix.org" "https://mirrors.ustc.edu.cn/nix-channels/store"];
      # trusted-public-keys = ["xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="];

      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = ["randy" "nestor"];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 21d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
