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
      # music-player-launch-cmd = "${pkgs.lib.getExe pkgs.firefoxpwa} site launch ${yt-music-pwa-site-id}";
      music-player-launch-cmd = pkgs.lib.getExe pkgs.supersonic;
      alacritty = pkgs.lib.getExe pkgs.alacritty;
      firefox = pkgs.lib.getExe pkgs.firefox;
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systmctl";
      tofi-drun = "${pkgs.tofi}/bin/tofi-drun";
      cliphist = pkgs.lib.getExe pkgs.cliphist;
      tofi = pkgs.lib.getExe pkgs.tofi;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      hyprshot = pkgs.lib.getExe pkgs.hyprshot;
      hyprpicker = pkgs.lib.getExe pkgs.hyprpicker;
      bash = pkgs.lib.getExe pkgs.bash;
      "write_to_layout_pipe.sh" = "${pkgs.writeShellScript "write_to_layout_pipe" ''
        #!${pkgs.bash}/bin/sh
        FIFO_PATH=$XDG_RUNTIME_DIR/layout_fifo_pipe

        if [[ ! -p "$FIFO_PATH" ]]; then
            echo "Creating fifo pipe at \"$FIFO_PATH\""
            mkfifo "$FIFO_PATH" 2>&1
        fi
        echo "Using existing fifo pipe at \"$FIFO_PATH\""

        echo "Outputting \"${
          pkgs.lib.getExe inputs.xkb-get-layout.packages.${system}.default
        }\" to fifo pipe"

        # https://github.com/fqidz/xkb-get-layout
        ${pkgs.lib.getExe inputs.xkb-get-layout.packages.${system}.default} > "$FIFO_PATH"
      ''}";

      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      playerctl = pkgs.lib.getExe pkgs.playerctl;
      brightnessctl = pkgs.lib.getExe pkgs.brightnessctl;
      DEFAULT_AUDIO_SINK = null;
    });
  };
}
