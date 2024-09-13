{ pkgs, ... }:
{
  home.packages = [
    pkgs.brightnessctl
    pkgs.hyprcursor
    pkgs.hyprshot
    pkgs.libnotify
    pkgs.playerctl
    pkgs.cliphist
  ];
}
