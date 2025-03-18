{
  pkgs,
  config,
  ...
}: {
  programs.foot = {
    package = pkgs.unstable.foot;
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=16";
        selection-target = "both"; # Save to clipboard and primary selection
      };
      colors = {
        foreground = "000000";
        background = "FFFFFF";

        # Normal colors
        regular0 = "000000"; # black
        regular1 = "0C322F"; # red
        regular2 = "019E07"; # green
        regular3 = "F58900"; # yellow
        regular4 = "068BD2"; # blue
        regular5 = "033682"; # magenta
        regular6 = "EAA198"; # cyan
        regular7 = "FFFFFF"; # white

        # Bright colors
        bright0 = "000000"; # bright black
        bright1 = "0C322F"; # bright red
        bright2 = "019E07"; # bright green
        bright3 = "F58900"; # bright yellow
        bright4 = "068BD2"; # bright blue
        bright5 = "033682"; # bright magenta
        bright6 = "0AA198"; # bright cyan
        bright7 = "FFFFFF"; # bright white
      };
    };
  };
}
