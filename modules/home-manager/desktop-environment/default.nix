# { lib, config, ... }:
# let
#   cfg = config.myHmModules.desktop-environment;
# in
{
  imports = [
    ./hyprland
    ./eww
    ./hyprpaper
    ./dunst.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./tofi.nix
    ./cliphist.nix
  ];

  # options.myHmModules.desktop-environment = {
  #   enable = lib.mkEnableOption "Desktop Environment";
  #   compositor = lib.mkOption {
  #     type = lib.types.nullOr lib.types.enum [
  #       "hyprland"
  #     ];
  #     default = null;
  #     description = "Enable a desktop environment";
  #   };
  # };

  # config = lib.mkIf cfg.enable {
  #   if cfg.compositor == "hyprland" then
  #
  #   else
  # };
}
