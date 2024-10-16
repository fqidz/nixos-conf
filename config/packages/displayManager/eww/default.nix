{ pkgs, ... }:
{
  home.packages = [
    pkgs.eww
  ];

  programs.eww = {
    enable = true;
    configDir = ./eww-config;
  };

  home.file.".config/eww-modules" = {
    source = ./eww-modules;
    recursive = true;
  };
}
