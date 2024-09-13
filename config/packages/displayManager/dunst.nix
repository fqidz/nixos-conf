{ pkgs, ... }:
{
  home.packages = [
    pkgs.dunst
    pkgs.libnotify
  ];

  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          width = "(200, 300)";
          height = "(100, 200)";
          origin = "top-right";
          offset = "30x50";
          icon_corner_radius = 10;
          corner_radius = 15;
          font = "Roboto Mono";
        };
      };
    };
  };
}
