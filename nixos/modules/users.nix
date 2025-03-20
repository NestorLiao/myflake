{
  pkgs,
  config,
  userSetting,
  inputs,
  outputs,
  ...
}: {
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs userSetting;};
    useUserPackages = true;
    users = {
      # Import your home-manager configuration
      ${userSetting.username} = import ../../home-manager/home.nix;
    };
  };

  users.users = {
    ${userSetting.username} = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "n";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      shell = pkgs.unstable.fish;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "audio" "plugdev" "docker" "dialout" "storage" "wireshark"];
    };
  };
  users.defaultUserShell = pkgs.unstable.fish;
  security.sudo.wheelNeedsPassword = false;
}
