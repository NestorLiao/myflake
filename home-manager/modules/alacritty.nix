{ pkgs, config, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      selection.save_to_clipboard = true;
      env.TERM = "xterm-256color";
      font = let family = "Noto Sans Mono"; in {
        size = 10;
        normal = {
          inherit family;
          style = "Medium";
        };
        bold = {
          inherit family;
          style = "Bold";
        };
        italic = {
          inherit family;
          style = "Italic";
        };
        bold_italic = {
          inherit family;
          style = "Bold";
        };
    };
    colors = {
        primary = {
          background = "#ffffff";
          foreground = "#000000";
        };
        normal = {
          black = "#000000";
          red = "#000000";
          green = "#000000";
          yellow = "#000000";
          blue = "#000000";
          magenta = "#000000";
          cyan = "#000000";
          white = "#ffffff";
        };
        bright = {
          black = "#000000";
          red = "#000000";
          green = "#000000";
          yellow = "#000000";
          blue = "#000000";
          magenta = "#000000";
          cyan = "#000000";
          white = "#ffffff";
        };
      };
    };
  };
}
