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
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 75%-";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 280;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 300;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
  };
}
