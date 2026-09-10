{ pkgs, ... }:
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 28;
    };
  };
}
