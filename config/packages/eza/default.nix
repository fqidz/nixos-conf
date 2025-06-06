{ pkgs, ... }:
{
  home.packages = [
    pkgs.eza
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [
      "--icons"
      "--classify"
      "--oneline"
      "--tree"
      "--level=1"
      "--group-directories-first"
    ];
  };
}
