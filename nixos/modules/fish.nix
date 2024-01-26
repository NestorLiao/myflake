{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -x DIRENV_LOG_FORMAT ""
    '';
    shellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
      thefuck --alias | source
      clear
    '';

    shellAbbrs = {
      "find" = "fd";
      "py" = "python";
      "snr" = "sudo nixos-rebuild switch --show-trace";
      "cr" = "cht.sh rust | less";
      "c" = "cht.sh | less";
      "e" = "hx";
      "en" = "hx .";
      "r" = "fg";
      # "diff" = "nvim -d";
      "grep" = "rg";
      # "vi" = "hx";
      "ls" = "eza";
      "nix" = "nom";
      # "mann" = "tldr";
      # "tree" = "lf";
      # "sed" = "sd";
      # "df" = "duf";
      # "du" = "gdu";
      # "ping" = "gping";
      # "mpc" = "vimpc";
      # "top" = "gotop";
      # "cat" = "bat";
      # "sh" = "nix shell nixpkgs#";
      # "nixh" = "nix-prefetch-url";
      # "nixhu" = "nix-prefetch-url --unpack";
      # "sys" = "systemctl";
      # "sysu" = "systemctl --user";
      # "up" = "nixos-rebuild --flake .# build";
      # "upp" = "doas nixos-rebuild --flake .# switch";
    };
  };
}
