{ pkgs, ... }:
let
  timeoutScript = command: pkgs.writeShellScript "suspend-script" ''
    active_window=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -rc '.class')
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
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = brightnessScript.outPath;
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 280;
            on-timeout = screenOffScript.outPath;
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
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
