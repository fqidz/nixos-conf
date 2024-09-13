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
        ];
        wallpaper = [
          ", ${./wallpapers/rose-pine-abstract.png}"
        ];
      };
    };
  };
}
