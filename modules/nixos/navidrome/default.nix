{ config, ... }:
{
  sops.secrets."lastfm.env".sopsFile = ../../../secrets/navidrome.yaml;
  services.navidrome = {
    enable = true;
    openFirewall = true;
    environmentFile = config.sops.secrets."lastfm.env".path;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/mnt/music";
      # LastFM api & secret keys inside env file
      "LastFM.Enabled" = true;
    };
  };
}
