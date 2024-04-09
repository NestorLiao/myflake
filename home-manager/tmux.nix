{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [sensible yank resurrect continuum];
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    # resurrect_dir="$HOME/.tmux/resurrect"
    # set -g @resurrect-dir $resurrect_dir
    # set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g" $target | sponge $target'
    # set -g @resurrect-capture-pane-contents 'on'

    extraConfig = ''
      resurrect_dir="$HOME/.tmux/resurrect"
      set -g @resurrect-dir $resurrect_dir
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-hook-post-save-all "sed 's/--cmd[^ ]* [^ ]* [^ ]*//g' $resurrect_dir/last | sponge $resurrect_dir/last"

      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-continuum'

      set -g @resurrect-processes 'hx bacon'
      set -g @continuum-restore 'on'
      set -g @continuum-boot 'on'
      set  -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",alacritty:RGB"
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g status off

      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy -in -selection clipboard'
      bind-key -r Bspace kill-pane;
      bind -r Space select-pane -l
      bind-key -r Enter split-window -v -p 50 -c "#{pane_current_path}" \; select-pane -l;
      bind-key -n C-j select-pane -D
      bind-key -n C-l last-window
      bind-key -n C-n resize-pane -Z
      bind v copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind '"' split-window -v -c "#{pane_current_path}"
      bind-key x kill-pane
      bind -n C-o display-popup -E "tms"
      bind j display-popup -E "tms switch"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
