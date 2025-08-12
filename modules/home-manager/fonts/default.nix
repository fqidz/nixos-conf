{ pkgs, ... }:
{
  home.packages = [
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.nerd-fonts.roboto-mono
    pkgs.charis-sil
    pkgs.inter
  ];

  fonts.fontconfig.enable = true;
}
