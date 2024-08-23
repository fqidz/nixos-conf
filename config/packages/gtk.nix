{ config, pkgs, libs, ... }:

{
  gtk = {
    enable = true;
    gtk4.extraConfig = {
      color-scheme = "prefer-dark";
    };
  };
}
