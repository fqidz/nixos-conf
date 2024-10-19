{ pkgs, ... }:
{
  home.packages = [
    pkgs.eww
  ];

  programs.eww = {
    enable = true;
    configDir = ./eww-config;
  };

  home.file.".config/eww-scripts" = {
    source = ./eww-scripts;
    recursive = true;
  };
  systemd.user.services.eww-bar = {
    Unit = {
      Description = "Starts eww";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "eww-bar" ''
        #!${pkgs.bash}/bin/sh
        ${pkgs.eww}/bin/eww kill
        ${pkgs.eww}/bin/eww daemon
        ${pkgs.eww}/bin/eww open "bar"
      ''}";
    };
  };
}
