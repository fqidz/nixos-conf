{ pkgs, rootPath, ... }:
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
          "${rootPath}/configFiles/wallpapers/rose-pine-abstract.png"
        ];
        wallpaper = [
          ", ${rootPath}/configFiles/wallpapers/rose-pine-abstract.png"
        ];
      };
    };
  };
}
