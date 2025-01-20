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
    userEmail = "faidz.arante@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      diff.tool = "nvimdiff";
      merge.tool = "nvimdiff3";
    };
  };
}
