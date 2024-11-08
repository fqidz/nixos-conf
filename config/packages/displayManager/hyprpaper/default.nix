{ pkgs, ... }:
{
  home.packages = [
    pkgs.hyprpaper
  ];

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = true;
        splash = false;
        preload = [
          "${./wallpapers/rose-pine-abstract.png}"
          # ./a_man_standing_on_a_car.png
        ];
        wallpaper = [
          ", ${./wallpapers/rose-pine-abstract.png}"
          # ", {./a_man_standing_on_a_car.png}"
        ];
      };
    };
  };
}
