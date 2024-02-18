{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInit = ''
      set -x DIRENV_LOG_FORMAT ""
      fish_vi_key_bindings
      zoxide init fish | source
      clear
    '';
  };
}
