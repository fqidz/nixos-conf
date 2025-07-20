{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # use UWSM as recommended, instead of using systemd session directly.
    withUWSM = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
    systemPackages = [
      (pkgs.where-is-my-sddm-theme.override {
        themeConfig.General = {
          backgroundFill = "#191724";
          basicTextColor = "#e0def4";
          passwordInputWidth = "0.75";
          passwordCursorColor = "#e0def4";
          passwordInputCursorVisible = true;
          cursorBlinkAnimation = true;
          hideCursor = true;
        };
      })
    ];
  };

  services.displayManager = {
    enable = true;
    # sessionPackages = [ pkgs.hyprland ];
    sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = [
        pkgs.qt6.qt5compat
      ];

      settings = {
        # General.DefaultSession = "hyprland-uwsm";
        Users = {
          RememberLastSession = true;
          RememberLastUser = true;
        };
      };
    };
  };
}
