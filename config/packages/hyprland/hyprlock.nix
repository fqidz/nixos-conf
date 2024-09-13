{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprlock
  ];

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          no_fade_out = true;
          immediate_render = true;
        };

        background = {
          monitor = "";
          color = "rgba(25, 23, 36, 1.0)";
          blur_passes = 0;
        };

        input-field = {
          monitor = "";
          size = "1500, 200";
          outline_thickness = -1;
          dots_size = 0.33;
          dots_spacing = 0.25;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(0, 0, 0, 0.0)";
          inner_color = "rgba(0, 0, 0, 0.0)";
          font_color = "rgb(224, 222, 244)";
          fade_on_empty = false;
          placeholder_text = "";
          fail_color = "rgb(235, 111, 146)";
          fail_text = "";

          position = "0, 0";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
