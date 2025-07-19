{ lib, pkgs, home, ... }:
let
  # fontPkg = pkgs.nerd-fonts.roboto-mono;
  # fontName = lib.mkIf (builtins.elem fontPkg home.packages) fontPkg.name;
  fontName = "RobotoMono Nerd Font";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ ./rose-pine.toml ];
      font = {
        offset = {
          y = -1;
        };
        size = 12;
        normal.family = fontName;
        italic = {
          family = fontName;
          style = "Italic";
        };
        bold = {
          family = fontName;
          style = "Medium";
        };
        bold_italic = {
          family = fontName;
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
