#
# users.nix
#
# Configure the users
#
{
  pkgs,
  config,
  userSetting,
  inputs,
  outputs,
  ...
}: {
  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs userSetting;};
    # useGlobalPkgs = true;
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
      shell = pkgs.fish;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "audio" "plugdev" "docker" "dialout" "storage"];
    };
  };

  users.defaultUserShell = pkgs.fish;
  security.sudo.wheelNeedsPassword = false;
}
