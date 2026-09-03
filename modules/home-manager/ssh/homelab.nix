{ config, ... }:
{
  programs.ssh.matchBlocks = {
    "github.com" = {
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/github_id_ed25519";
    };
  };
}
