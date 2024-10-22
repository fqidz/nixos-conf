{ pkgs, ... }:
{
  home.packages = [
    pkgs.git
    pkgs.git-lfs
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "fqidz";
    userEmail = "meowthful127@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      diff.tool = "nvimdiff";
    };
  };
}
