{ pkgs, config, username, ... }:
{
  systemd.user = {
    enable = true;
    timers."uobwiki-sitemap" = {
      Timer = {
        OnCalendar = "*-*-* 03:17:00 Asia/Bahrain";
        Unit = "uobwiki-sitemap.service";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
    services."uobwiki-sitemap" = {
      Service = {
        ExecStart = [
          "${pkgs.lib.getExe pkgs.podman} exec uobwiki /usr/local/bin/php /var/www/html/maintenance/run.php generateSitemap --fspath=/var/www/html/sitemap/ --urlpath=/sitemap/ --compress=no --skip-redirects --identifier=en --wiki=enwiki"
          "${pkgs.lib.getExe pkgs.podman} exec uobwiki /usr/local/bin/php /var/www/html/maintenance/run.php generateSitemap --fspath=/var/www/html/sitemap/ --urlpath=/sitemap/ --compress=no --skip-redirects --identifier=ar --wiki=arwiki"
          "${pkgs.lib.getExe pkgs.podman} exec uobwiki /usr/local/bin/php /var/www/html/maintenance/run.php generateSitemap --fspath=/var/www/html/sitemap/ --urlpath=/sitemap/ --compress=no --skip-redirects --identifier=files --wiki=fileswiki"
        ];
        Type = "oneshot";
        User = username;
      };
    };
  };
}
