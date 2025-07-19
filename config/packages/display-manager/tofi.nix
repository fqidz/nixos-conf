{ pkgs, ... }:
{
  home.packages = [
    pkgs.tofi
  ];

  programs = {
    tofi = {
      enable = true;
      settings = {
        font = "${pkgs.nerd-fonts.roboto-mono.outPath}/share/fonts/truetype/NerdFonts/RobotoMono/RobotoMonoNerdFont-Medium.ttf";
        font-size = 20;
        width = 800;
        height = 540;
        background-color = "#191724e6";
        text-color = "#e0def4";
        selection-color = "#9ccfd8";
        prompt-text = "\"\"";
        num-results = 5;
        result-spacing = 10;
        outline-width = 0;
        border-width = 1;
        border-color = "#c4a7e7";
        corner-radius = 10;
        padding-top = 110;
        padding-bottom = 20;
        padding-right = 110;
        padding-left = 110;
        clip-to-padding = true;
        hide-cursor = true;
        text-cursor = true;
        # matching-algorithm = "fuzzy"; # not working
        fuzzy-match = true;
      };
    };
  };
}
