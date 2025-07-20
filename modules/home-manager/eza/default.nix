{ ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [
      "--icons"
      "--classify"
      "--oneline"
      "--tree"
      # https://github.com/eza-community/eza/issues/1499
      "--level=1"
      "--group-directories-first"
    ];
  };
}
