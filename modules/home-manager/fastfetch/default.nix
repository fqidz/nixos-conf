{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nix";
        padding = {
          left = 1;
        };
      };
      modules = [
        "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de"
          "wm"
          # "wmtheme"
          # "theme"
          # "icons"
          # "font"
          # "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          # "gpu"
          "memory"
          "swap"
          "disk"
          # "localip"
          "battery"
          "poweradapter"
          # "locale"
          "break"
          "colors"
          ];
    };
  };
}
