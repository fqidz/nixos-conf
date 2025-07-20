{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      extraOptions = [
        "--no-default-folder"
        "--no-browser"
        "--config=${config.xdg.configHome}/syncthing"
        "--data=${config.xdg.dataHome}/syncthing"
      ];
    };
  };
}
