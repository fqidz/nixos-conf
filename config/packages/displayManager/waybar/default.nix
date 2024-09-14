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
          margin-top = 5;
          margin-left = 15;
          margin-bottom = -10;
          margin-right = 15;
          spacing = 0;

          modules-left = [
            "custom/logo"
            "custom/spacer"
            "cpu"
            "memory"
            "temperature"
            "disk"
          ];

          modules-center = [
            "hyprland/workspaces"
            "hyprland/window"
          ];

          modules-right = [
              "battery"
              "backlight"
              "pulseaudio"
              "network"
              "clock"
          ];

          "hyprland/window" = {
              format = "";
          };

          # ---- modules-left ----
          "custom/logo" = {
              format = "";
              tooltip = false;
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
          "hyprland/workspaces" = {
              all-outputs = true;
              active-only = false;
              on-click = "activate";
              format = "{icon}";
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
              format-icons = {
                  "1" = "";
                  "2" = "";
                  "3" = "";
                  "4" = "";
                  "5" = "";
                  "6" = "";
                  "7" = "";
                  "8" = "";
                  "9" = "";
                  "urgent" = "";
                  "active" = "";
                  "default" = "";
              };
          };

          # ---- modules-right ----
          "battery" = {
              bat = "BAT1";
              interval = 20;
              states = {
                  "warning" = 20;
                  "critical" = 10;
              };
              format = "{icon} {capacity}%";
              format-alt = "{icon} {time}";
              format-charging = "󰂄 {capacity}%";
              format-charging-alt = "󱧦 {time}";
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
              tooltip-format = "{capacity}%\n{time}";
          };

          "backlight" = {
              device = "amdgpu_bl1";
              format = "{icon} {percent}%";
              format-icons = ["" "" "" "" "" "" "" "" ""];
              tooltip = false;
          };

          "pulseaudio" = {
              scroll-step = 1;
              format = "{icon} {volume}%";
              format-bluetooth = "󰂯 {volume}%";
              format-muted = " ";
              format-icons = {
                  "default" = [ "" "" ];
                  "headphone" = "";
              };
              tooltip = false;
          };

          "network" = {
              format-wifi = "󰖩 {essid}";
              format-alt = "󰖩 {bandwidthTotalBits}";
              format-ethernet = "󰈀 wired";
              format-disconnected = "󱛅 ";
              tooltip-format-wifi = "{ifname} {signalStrength}%";
              tooltip-format-ethernet = "{ifname}";
              tooltip-format-disconnected = "Disconnected";
          };

          "clock" = {
              interval = 60;
              format = "{:%I:%M %p}";
          };

          # ---- misc -----
          "custom/spacer" = {
              format = " ";
          };
        };
      };

      style = builtins.readFile ./waybar.css;
    };
  };
}

