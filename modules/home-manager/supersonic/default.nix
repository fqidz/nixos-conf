{ pkgs, ... }:
{
  home.packages = [
    pkgs.supersonic
  ];

  services.gnome-keyring.enable = true;
}
