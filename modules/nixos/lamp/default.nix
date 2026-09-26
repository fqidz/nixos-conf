{ pkgs, username, ... }:
{
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  services = {
    httpd = {
      enable = true;
      adminAddr = "webmaster@example.org";
      enablePHP = true;
      enablePerl = true;
      virtualHosts = {
        "127.0.0.1:7100" = {
          listen = [
            {
              ip = "127.0.0.1";
              port = 7100;
            }
          ];
          documentRoot = "/var/www/itts401";
          locations."/adminer/index.php" = {
            alias = "${pkgs.adminer}/adminer.php";
          };
        };
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };

  security.acme.acceptTerms = true;

  # systemd.tmpfiles.rules = [
  #   "d /var/www/mypage - ${username} ${username}"
  #   "f /var/www/mypage/index.php - - - - <?php phpinfo();"
  # ];
}
