{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.supersonic
  ];

  services.gnome-keyring.enable = true;
}
