{ pkgs, ... }:
{
  programs.firefoxpwa.profiles."01KH8P3MWAKD68KT2VQXAKKH6J" = {
    name = "YouTube Music";
    sites."01KH8P5D2CE8DVWSH80MG1FS6X" = {
      name = "YouTube Music";
      url = "https://music.youtube.com/";
      manifestUrl = "https://music.youtube.com/manifest.webmanifest";
      desktopEntry = {
        enable = true;
        categories = [ "Audio" "AudioVideo" "Music" ];
        icon = pkgs.fetchurl {
          url = "https://www.gstatic.com/youtube/media/ytm/images/applauncher/music_icon_192x192.png";
          sha256 = "sha256-HrzWr2z5w0zFn/BatXFikEQmEzDgsCD0qFj+/MvXEio=";
        };
      };
    };
  };
}
