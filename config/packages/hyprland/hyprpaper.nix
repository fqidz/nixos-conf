{ pkgs, config, ... }:
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
          "${config.xdg.configHome}/wallpapers/rose-pine-abstract.png"
        ];
        wallpaper = [
          ", ${config.xdg.configHome}/wallpapers/rose-pine-abstract.png"
        ];
      };
    };
  };
}
