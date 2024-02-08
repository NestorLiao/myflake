{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -x DIRENV_LOG_FORMAT ""
    '';
    shellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
      clear
    '';
  };

  users.defaultUserShell = pkgs.fish;
}
