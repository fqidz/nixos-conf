{ pkgs, ... }:
let
  waybarPackage = (pkgs.waybar.override { withMediaPlayer = true; });
in
{
  home.packages = [
    waybarPackage
  ];

  programs = {
    waybar = {
      package = waybarPackage;
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
            "custom/spacer"
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
            "custom/media"
            "custom/spacer"
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
            format = " {usage}%";
            on-click = "";
          };

          "memory" = {
            interval = 10;
            max-length = 10;
            format = "  {used:0.1f}G";
            tooltip-format = "{used:0.2f}GiB out of {total:0.2f}GiB ({percentage}%)";
            on-click = "";
          };

          "temperature" = {
            interval = 10;
            hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
            critical-threshold = 60;
            format-critical = "󰈸 {temperatureC}°C";
            format = " {temperatureC}°C";
            tooltip-format = "{temperatureF}°F\n{temperatureK}K";
            on-click = "";
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
            format = "{:%a %b %d <span color='#393552'>｜</span> %R}";
            on-click = "";
          };

          # ---- modules-right ----
          "custom/media" = {
            format = "<span text_transform='lowercase'>{}</span>";
            return-type = "json";
            max-length = 40;
            # format-icons = {
            #   "spotify" = " ";
            #   "firefox" = " ";
            #   "default" = " ";
            # };
            escape = true;
            on-click = "playerctl play-pause";
            exec = "${waybarPackage}/bin/waybar-mediaplayer.py 2> /dev/null";
            tooltip = false;
          };

          "battery" = {
            bat = "BAT1";
            interval = 20;
            format = "<span letter_spacing='-10000'>{icon}</span> {capacity}%";
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
            on-click = "";
          };

          "backlight" = {
            device = "amdgpu_bl1";
            format = "{icon}";
            scroll-step = 1;
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
            format-muted = "<span color='#ebbcba'>  </span>";
            format-icons = {
              "default" = [
                " "
                " "
              ];
              "headphone" = [
                " "
                " "
              ];
            };
            tooltip-format = "{desc}\nVolume: {volume}%";
            on-click = "";
          };

          "network" = {
            format-wifi = "󰖩 ";
            format-ethernet = "󰈀 ";
            format-disconnected = "󱛅 ";
            tooltip-format-wifi = "{essid}\n{ifname}\n{signalStrength}%";
            tooltip-format-ethernet = "{ifname}";
            tooltip-format-disconnected = "Disconnected";
          };

          # ------ misc ------
          "custom/spacer" = {
            format = "｜";
          };

        };
      };

      style = builtins.readFile ./waybar.css;
    };
  };
}
