{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "fqidz";
    userEmail = "faidz.arante@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      diff.tool = "nvimdiff";
      merge.tool = "nvimdiff3";
      commit.gpgsign = true;
      tag.gpgSign = true;
    };
  };
}
