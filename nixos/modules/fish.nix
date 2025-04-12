{ pkgs, ... }: {
  programs.fish = {
    package = pkgs.unstable.fish;
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellInit = ''
       # set -x DIRENV_LOG_FORMAT ""
       zoxide init fish | source
       # clear
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
}
