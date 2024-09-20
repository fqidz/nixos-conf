{ pkgs, ... }:
{
  home.packages = [
    pkgs.yazi
    pkgs.ueberzugpp
  ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 10;
      };

      preview = {
        tab_size = 4;
        max_width = 1920;
        max_height = 1080;
        image_filter = "triangle";
        image_quality = 50;
        wrap = "no";
      };

    };

  };
}
