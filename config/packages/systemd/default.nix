{ pkgs, username, ... }:
{
  home.packages = [
    pkgs.systemd
  ];

  systemd.user = {
    enable = true;
    tmpfiles.rules = [
      "d /home/${username}/.nvim-sessions 0755 ${username} -"
    ];
  };
}
