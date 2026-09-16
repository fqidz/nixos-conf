{ config, ... }:
{
  sops.secrets."syncthing-pass" = {
    key = "pass";
    sopsFile = ../../../secrets/syncthing.yaml;
  };

  services = {
    syncthing = {
      enable = true;
      extraOptions = [
        "--no-browser"
        "--config=${config.xdg.configHome}/syncthing"
        "--data=${config.xdg.dataHome}/syncthing"
      ];
      guiAddress = "[::]:8384";
      guiCredentials = {
        username = "faidz";
        passwordFile = config.sops.secrets."syncthing-pass".path;
      };
    };
  };
}
