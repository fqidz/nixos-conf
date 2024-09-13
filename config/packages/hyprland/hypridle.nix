{ pkgs, ... }:
{
  home.packages = [
    pkgs.hypridle
  ];
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          lock_cmd = "hyprlock";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 75%-";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 280;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 300;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
