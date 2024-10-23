{ pkgs, ... }:
let
  font = "RobotoMono Nerd Font";
in
{
  home.packages = [
    pkgs.alacritty
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      import = [ "${./rose-pine.toml}" ];
      font = {
        offset = {
          y = -1;
        };
        size = 12;
        normal = {
          family = font;
        };
        italic = {
          family = font;
          style = "Italic";
        };
        bold = {
          family = font;
          style = "Medium";
        };
        bold_italic = {
          family = font;
          style = "MediumItalic";
        };
      };

      window = {
        decorations = "None";

        padding = {
          x = 10;
          y = 5;
        };
      };

      keyboard.bindings = [
        {
          key = "N";
          mods = "Command";
          action = "CreateNewWindow";
        }
      ];

    };
  };
}
