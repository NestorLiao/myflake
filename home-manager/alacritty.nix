{
  pkgs,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      selection.save_to_clipboard = true;
      env.TERM = "xterm-256color";
      font = let
        family = "Noto Sans Mono";
      in {
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
        # primary = {
        #   background = "#ffffff";
        #   foreground = "#000000";
        # };
        # normal = {
        #   black = "#000000";
        #   red = "#000000";
        #   green = "#000000";
        #   yellow = "#000000";
        #   blue = "#000000";
        #   magenta = "#000000";
        #   cyan = "#000000";
        #   white = "#ffffff";
        # };
        # bright = {
        #   black = "#000000";
        #   red = "#000000";
        #   green = "#000000";
        #   yellow = "#000000";
        #   blue = "#000000";
        #   magenta = "#000000";
        #   cyan = "#000000";
        #   white = "#ffffff";
        # };

        # primary = {
        #   background = "#f8f8f8";
        #   foreground = "#2a2b33";
        # };
        # normal = {
        #   black = "#000000";
        #   red = "#de3d35";
        #   green = "#3e953a";
        #   yellow = "#d2b67b";
        #   blue = "#2f5af3";
        #   magenta = "#a00095";
        #   cyan = "#3e953a";
        #   white = "#bbbbbb";
        # };
        # bright = {
        #   black = "#000000";
        #   red = "#de3d35";
        #   green = "#3e953a";
        #   yellow = "#d2b67b";
        #   blue = "#2f5af3";
        #   magenta = "#a00095";
        #   cyan = "#3e953a";
        #   white = "#ffffff";
        # };

        primary = {
          background = "0xffffff";
          foreground = "0x0e1116";
        };
        cursor = {
          text = "0xffffff";
          cursor = "0x0e1116";
        };
        normal = {
          black = "0x0e1116";
          red = "0xa0111f";
          green = "0x024c1a";
          yellow = "0x3f2200";
          blue = "0x0349b4";
          magenta = "0x622cbc";
          cyan = "0x1b7c83";
          white = "0x66707b";
        };
        bright = {
          black = "0x4b535d";
          red = "0x86061d";
          green = "0x055d20";
          yellow = "0x4e2c00";
          blue = "0x1168e3";
          magenta = "0x622cbc";
          cyan = "0x1b7c83";
          white = "0x66707b";
        };
      };
    };
  };
}
