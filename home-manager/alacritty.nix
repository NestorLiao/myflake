{
  pkgs,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 16;
      selection.save_to_clipboard = true;
      env.TERM = "xterm-256color";

      colors = {
        bright = {
          black = "0x000000";
          blue = "0x068BD2";
          cyan = "0x0AA198";
          green = "0x019E07";
          magenta = "0x033682";
          red = "0x0C322F";
          white = "0xFFFFFF";
          yellow = "0x058900";
        };
        normal = {
          black = "0x000000";
          blue = "0x068BD2";
          cyan = "0x0AA198";
          green = "0x019E07";
          magenta = "0x033682";
          red = "0x0C322F";
          white = "0xFFFFFF";
          yellow = "0x058900";
        };
        primary = {
          background = "0xFFFFFF";
          foreground = "0x000000";
        };
      };
    };
  };
}
