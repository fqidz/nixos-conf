{ pkgs, username, ... }:
{
  home.packages = [
    pkgs.systemd
  ];

  systemd.user = {
    enable = true;
    services = {
      cliphist-history = {
        Unit = {
          Description = "Stores clipboard history using cliphist";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.writeShellScript "cliphist-history" ''
            #!${pkgs.bash}/bin/sh
            wl-paste --watch cliphist store
          ''}";
        };
      };

    };
    tmpfiles.rules = [
      "d /home/${username}/.nvim-sessions 0755 ${username} -"
    ];
  };
}
