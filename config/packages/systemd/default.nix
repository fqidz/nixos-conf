{ config, username, ... }:
{
  systemd.user = {
    enable = true;
    tmpfiles.rules = [
      "d ${config.home.homeDirectory}/.nvim-sessions 0755 ${username} -"
    ];
  };
}
