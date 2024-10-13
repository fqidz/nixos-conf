{ pkgs, ... }:
{
  home.packages = [
    pkgs.waybar
  ];

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        "mainBar" = {
          layer = "top";
          position = "top";
          height = 30;
          margin-top = 8;
          margin-left = 15;
          margin-bottom = -8;
          margin-right = 15;
          spacing = 0;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
            "cpu"
            "memory"
            "temperature"
            "disk"
          ];

          modules-center = [
            "clock"
          ];

          modules-right = [
            "backlight"
            "pulseaudio"
            "network"
            "battery"
          ];

          "hyprland/window" = {
            format = "";
          };

          # ---- modules-left ----
          "hyprland/workspaces" = {
            all-outputs = true;
            active-only = false;
            on-click = "activate";
            format = "{icon}";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            format-icons = {
              "1" = " ";
              "2" = " ";
              "3" = " ";
              "4" = " ";
              "5" = " ";
              "6" = " ";
              "7" = " ";
              "8" = " ";
              "9" = " ";
              "urgent" = " ";
              "active" = " ";
              "default" = " ";
            };
          };
          "cpu" = {
            interval = 10;
            max-length = 10;
            format = " {usage}%";
            on-click = "";
          };

          "memory" = {
            interval = 10;
            max-length = 10;
            format = "  {used:0.1f}G";
            tooltip-format = "{used:0.2f}GiB out of {total:0.2f}GiB ({percentage}%)";
          };

          "temperature" = {
            interval = 10;
            hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
            critical-threshold = 60;
            format-critical = "󰈸 {temperatureC}°C";
            format = " {temperatureC}°C";
            tooltip-format = "{temperatureF}°F\n{temperatureK}K";
          };

          "disk" = {
            interval = 30;
            format = " {percentage_used}%";
            tooltip-format = "{specific_used:0.2f}G used out of {specific_total:0.2f}G";
            unit = "GB";
          };

          # ---- modules-center ----
          "clock" = {
            interval = 60;
            format = "{:%a %b %d  %R}";
          };

          # ---- modules-right ----
          "battery" = {
            bat = "BAT1";
            interval = 20;
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            tooltip-format = "{capacity}%\n{time}";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };

          "backlight" = {
            device = "amdgpu_bl1";
            format = "{icon}";
            format-icons = [
              " "
              " "
              " "
              " "
              " "
              " "
              " "
              " "
              " "
            ];
            tooltip-format = "Brightness: {percent}%";
          };

          "pulseaudio" = {
            scroll-step = 1;
            format = "{icon}";
            # format-bluetooth = "󰂯 {volume}%";
            format-muted = " ";
            format-icons = {
              "default" = [
                " "
                " "
                # "⣀"
                # "⣄"
                # "⣤"
                # "⣦"
                # "⣶"
                # "⣷"
                # "⣿"
              ];
              # "headphone" = "󰋋";
            };
            tooltip-format = "Volume: {volume}%";
          };

          "network" = {
            format-wifi = "󰖩 ";
            format-ethernet = "󰈀 ";
            format-disconnected = "󱛅 ";
            tooltip-format-wifi = "{essid}\n{ifname}\n{signalStrength}%";
            tooltip-format-ethernet = "{ifname}";
            tooltip-format-disconnected = "Disconnected";
          };

        };
      };

      style = builtins.readFile ./waybar.css;
    };
  };
}
