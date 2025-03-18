{pkgs, ...}: {
  programs.fish = {
    package = pkgs.unstable.fish;
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInit = ''
       set -x DIRENV_LOG_FORMAT ""
       zoxide init fish | source
       clear
       function vterm_printf;
           if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
               # tell tmux to pass the escape sequences through
               printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
           else if string match -q -- "screen*" "$TERM"
               # GNU screen (screen, screen-256color, screen-256color-bce)
               printf "\eP\e]%s\007\e\\" "$argv"
           else
               printf "\e]%s\e\\" "$argv"
           end
       end

       if [ "$INSIDE_EMACS" = 'vterm' ]
           function clear
               vterm_printf "51;Evterm-clear-scrollback";
               tput clear;
           end
       end

      function fish_title
          hostname
          echo ":"
          prompt_pwd
      end
    '';
  };

  # fish_vi_key_bindings
  programs.starship = {
    enable = false;
    settings = {
      add_newline = false;
      format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      command_timeout = 1000;
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };
      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
    };
  };
}
