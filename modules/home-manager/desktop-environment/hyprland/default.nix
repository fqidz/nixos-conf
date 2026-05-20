{ pkgs, config, inputs, system, yt-music-pwa-site-id, ... }:
{
  home.packages = [
    pkgs.hyprland
    pkgs.hyprland-qtutils
    pkgs.brightnessctl
    pkgs.hyprcursor
    pkgs.hyprshot
    pkgs.playerctl
    pkgs.hyprpicker
    pkgs.hyprpolkitagent
    inputs.xkb-get-layout.packages.${system}.default
  ];

  # systemd.user.tmpfiles.rules = [
  #   "d .local/share/icons <MODE> <USER> <GROUP>"
  # ];

  # used by .luarc.json
  home.sessionVariables.HYPRLAND_LUA_STUB_PATH = "${pkgs.hyprland}/share/hypr/stubs";

  home.file."${config.xdg.dataHome}/icons/rose-pine-hyprcursor" = {
    source = ./hyprcursors/rose-pine-hyprcursor;
    recursive = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
    configType = "lua";
    extraConfig = builtins.readFile (pkgs.replaceVars ./hyprland.lua {
      inherit yt-music-pwa-site-id;
      alacritty = pkgs.lib.getExe pkgs.alacritty;
      firefox = pkgs.lib.getExe pkgs.firefox;
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systmctl";
      firefoxpwa = pkgs.lib.getExe pkgs.firefoxpwa;
      tofi-drun = "${pkgs.tofi}/bin/tofi-drun";
      cliphist = pkgs.lib.getExe pkgs.cliphist;
      tofi = pkgs.lib.getExe pkgs.tofi;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      hyprshot = pkgs.lib.getExe pkgs.hyprshot;
      hyprpicker = pkgs.lib.getExe pkgs.hyprpicker;
      bash = pkgs.lib.getExe pkgs.bash;
      "write_to_layout_pipe.sh" = ./write_to_layout_pipe.sh;
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      playerctl = pkgs.lib.getExe pkgs.playerctl;
      brightnessctl = pkgs.lib.getExe pkgs.brightnessctl;
      DEFAULT_AUDIO_SINK = null;
    });
  };
}
