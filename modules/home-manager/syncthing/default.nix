{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      extraOptions = [
        "--no-browser"
        "--config=${config.xdg.configHome}/syncthing"
        "--data=${config.xdg.dataHome}/syncthing"
      ];
    };
  };
}
