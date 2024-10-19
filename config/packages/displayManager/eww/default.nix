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

  systemd.user.services = {
    eww-daemon = {
      Unit = {
        Description = "Starts eww daemon";
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
      };
      Service = {
        ExecSearchPath = [
          "${pkgs.eww}/bin"
          # eww tries to invoke things via sh
          "${pkgs.bash}/bin"
          # scripts and tools used in event handlers
          "${pkgs.playerctl}/bin"
          # "${pkgs.hyprland}/bin"
          "${pkgs.socat}/bin"
          "${pkgs.pulseaudio}/bin"
          "${pkgs.jq}/bin"
          "${pkgs.gnused}/bin"
          "${pkgs.coreutils}/bin"
          # "${pkgs.systemd}/bin"
        ];
        ExecStart = "${pkgs.writeShellScript "eww-daemon-start" ''
          #!${pkgs.bash}/bin/sh
          ${pkgs.eww}/bin/eww kill
          ${pkgs.eww}/bin/eww daemon
        ''}";
        ExecReload = "${pkgs.writeShellScript "eww-daemon-reload" ''
          #!${pkgs.bash}/bin/sh
          ${pkgs.eww}/bin/eww reload
        ''}";
        Restart = "on-failure";
        RestartSteps = 5;
        RestartMaxDelaySec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    eww-bar = {
      Unit = {
        Description = "Opens eww bar";
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
        BindsTo = "eww-daemon.service";
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "eww-bar-start" ''
          #!${pkgs.bash}/bin/sh
          ${pkgs.eww}/bin/eww open "bar"
        ''}";
        Restart = "on-failure";
        RestartSteps = 5;
        RestartMaxDelaySec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}
