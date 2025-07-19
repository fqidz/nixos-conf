{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      # Use ssh through http because university wifi doesn't allow ssh
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
      "hetzner-vps" = {
        hostname = "91.99.219.243";
        user = "faidz";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/hetzner_id_ed25519";
      };
    };
  };
}
