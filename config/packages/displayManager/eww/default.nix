{ pkgs, ... }:
{
  home = {
    packages = [
      pkgs.eww
    ];

    file = {
      ".config/eww" = {
        source = ./eww-config;
        recursive = true;
      };
      ".config/eww-scripts" = {
        source = ./eww-scripts;
        recursive = true;
      };
    };
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
          # bash
          "${pkgs.bash}/bin"
          # playerctl
          "${pkgs.playerctl}/bin"
          # hyprctl
          "${pkgs.hyprland}/bin"
          # brightnessctl
          "${pkgs.brightnessctl}/bin"
          # socat
          "${pkgs.socat}/bin"
          # pactl
          "${pkgs.pulseaudio}/bin"
          # jq
          "${pkgs.jq}/bin"
          # sed
          "${pkgs.gnused}/bin"
          # grep
          "${pkgs.gnugrep}/bin"
          # cut, tr
          "${pkgs.coreutils}/bin"
          # awk
          "${pkgs.gawk}/bin"
          # acpi
          "${pkgs.acpi}/bin"
          # nmcli
          "${pkgs.networkmanager}/bin"
          # udevadm
          "${pkgs.systemd}/bin"
        ];
        ExecStart = "${pkgs.writeShellScript "eww-daemon-start" ''
          #!${pkgs.bash}/bin/sh
          ${pkgs.eww}/bin/eww daemon --no-daemonize -c ~/.config/eww
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
