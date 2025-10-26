{ pkgs, ... }:
{
  # home.packages = [
  #   # pkgs.wine
  #   # pkgs.winePackages.full
  #   # pkgs.protonup-qt
  #   # pkgs.bottles
  #   # pkgs.winetricks
  # ];

  programs.lutris = {
    enable = true;
    steamPackage = pkgs.steam;
    protonPackages = [ pkgs.proton-ge-bin ];
    winePackages = [ pkgs.wineWowPackages.full ];
  };
}
