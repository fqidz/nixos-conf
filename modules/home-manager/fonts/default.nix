{ pkgs, ... }:
{
  home.packages = [
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.nerd-fonts.roboto-mono
    pkgs.charis
    pkgs.inter
  ];

  fonts.fontconfig.enable = true;
}
