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
      user.signingkey = "1B1F59F736624A87B916E7ABF87B11C7012F2916";
    };
  };
}
