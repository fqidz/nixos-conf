{ pkgs, ... }:
{
  home.packages = [
    pkgs.cliphist
    pkgs.wl-clipboard
  ];

  systemd.user.services.cliphist-history = {
    Unit = {
      Description = "Stores clipboard history using cliphist";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecSearchPath = [
        "${pkgs.cliphist}/bin"
        "${pkgs.wl-clipboard}/bin"
      ];
      ExecStart = "${pkgs.writeShellScript "cliphist-history" ''
        #!${pkgs.bash}/bin/sh
        ${pkgs.wl-clipboard}/bin/wl-paste --watch cliphist store
      ''}";
    };
  };
}
