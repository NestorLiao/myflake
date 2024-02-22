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
        size = 12;
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

        #   primary = {
        #     background = "#f8f8f8";
        #     foreground = "#2a2b33";
        #   };
        #   normal = {
        #     black = "#000000";
        #     red = "#de3d35";
        #     green = "#3e953a";
        #     yellow = "#d2b67b";
        #     blue = "#2f5af3";
        #     magenta = "#a00095";
        #     cyan = "#3e953a";
        #     white = "#bbbbbb";
        #   };
        #   bright = {
        #     black = "#000000";
        #     red = "#de3d35";
        #     green = "#3e953a";
        #     yellow = "#d2b67b";
        #     blue = "#2f5af3";
        #     magenta = "#a00095";
        #     cyan = "#3e953a";
        #     white = "#ffffff";
        #   };
      };
    };
  };
}
