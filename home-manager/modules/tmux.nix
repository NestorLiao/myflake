{ pkgs, config, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [ sensible yank ];
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy -in -selection clipboard'
      bind-key -r Bspace kill-pane
      bind-key -r Enter split-window -v -p 20 -c "#{pane_current_path}"
      set  -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",alacritty:RGB"
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g status off
      bind v copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind '"' split-window -v -c "#{pane_current_path}"
      bind-key x kill-pane
      bind o display-popup -E "tms"
      bind j display-popup -E "tms switch"
      bind w display-popup -E "tms windows"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
