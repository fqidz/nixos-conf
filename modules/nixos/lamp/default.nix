{ pkgs, username, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    httpd = {
      enable = true;
      adminAddr = "webmaster@example.org";
      enablePHP = true;
      enablePerl = true;
      virtualHosts = {
        "127.0.0.1:80" = {
          documentRoot = "/var/www/mypage";
          # forceSSL = true;
          # enableACME = true;
        };
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };

  security.acme.acceptTerms = true;

  systemd.tmpfiles.rules = [
    "d /var/www/mypage - ${username} ${username}"
    "f /var/www/mypage/index.php - - - - <?php phpinfo();"
  ];
}
