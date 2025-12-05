{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.hyprpaper
  ];

  home.file."${config.xdg.dataHome}/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = true;
        splash = false;
        preload = [
          {
            monitor = "";
            path = "${config.xdg.dataHome}/wallpapers/rose-pine-abstract.png";
          }
        ];
        wallpaper = [
          {
            monitor = "";
            path = "${config.xdg.dataHome}/wallpapers/rose-pine-abstract.png";
          }
        ];
      };
    };
  };
}
