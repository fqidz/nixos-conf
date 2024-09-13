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
    ];
  };
}
