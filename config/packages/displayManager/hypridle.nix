{ pkgs, ... }:
let
  timeoutScript = command: pkgs.writeShellScript "suspend-script" ''
    active_window=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | jq -rc '.class')
    if [[ "$active_window" != "calibre-ebook-viewer" ]]; then
      ${command}
    fi
  '';
  brightnessScript = timeoutScript "${pkgs.brightnessctl}/bin/brightnessctl -s set 75%-";
  screenOffScript = timeoutScript "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
  suspendScript = timeoutScript "${pkgs.systemd}/bin/systemctl suspend";
in
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
            on-timeout = brightnessScript.outPath;
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 280;
            on-timeout = screenOffScript.outPath;
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 300;
            on-timeout = suspendScript.outPath;
          }
        ];
      };
    };
  };
}
