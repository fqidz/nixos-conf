{ pkgs, ... }:
{
  home.packages = [
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.nerd-fonts.roboto-mono
    pkgs.charis-sil
  ];

  fonts.fontconfig.enable = true;
}
