{ pkgs, ... }:
{
  programs = {
    fd = {
      enable = true;
      hidden = true;
    };

    fzf = {
      enable = true;
      defaultCommand = "fd --hidden --absolute-path --base-directory=$HOME";
      fileWidgetCommand = "fd --hidden --absolute-path --base-directory=$HOME";
      enableZshIntegration = true;
      # rose-pine colors
      colors = {
        fg = "#908caa";
        bg = "#191724";
        hl = "#ebbcba";
        "fg+" = ":#e0def4";
        "bg+" = ":#26233a";
        "hl+" = "#ebbcba";
        border = "#403d52";
        header = "#31748f";
        gutter = "#191724";
        spinner = "#f6c177";
        info = "#9ccfd8";
        pointer = "#c4a7e7";
        marker = "#eb6f92";
        prompt = "#908caa";
      };
    };
  };
}
