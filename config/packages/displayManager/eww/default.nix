{ pkgs, ... }:
{
  home.packages = [
    pkgs.eww
  ];

  programs.eww = {
    enable = true;
    configDir = ./eww-config;
  };

  home.file.".config/eww-scripts" = {
    source = ./eww-scripts;
    recursive = true;
  };
}
