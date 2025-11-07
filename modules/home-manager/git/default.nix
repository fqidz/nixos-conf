{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "fqidz";
        email = "faidz.arante@gmail.com";
      };
      init.defaultBranch = "main";
      diff.tool = "nvimdiff";
      merge.tool = "nvimdiff3";
      commit.gpgsign = true;
      tag.gpgSign = true;
    };
  };
}
