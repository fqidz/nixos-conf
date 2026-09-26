{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      # Use ssh through http because university wifi doesn't allow ssh
      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
      };
      "hetzner-vps" = {
        HostName = "91.99.219.243";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/hetzner_id_ed25519";
      };
      "homelab" = {
        HostName = "192.168.100.11";
        IdentitiesOnly = true;
        IdentityFile = "${config.home.homeDirectory}/.ssh/homelab";
      };
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
