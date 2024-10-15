{ pkgs, ... }:
{
  home.packages = [
    pkgs.eww
  ];
  programs.eww = {
    enable = true;
    enableZshIntegration = true;
    configDir = ./eww-config;
  };
}
