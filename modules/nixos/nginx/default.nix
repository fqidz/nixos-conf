{ pkgs, ... }:
{
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "faidz.arante@gmail.com";
    };
  };

  # https://www.f5.com/company/blog/nginx/avoiding-top-10-nginx-configuration-mistakes
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    package = pkgs.nginxMainline;
    enableReload = true;

    appendHttpConfig = ''
      access_log off;
    '';
    appendConfig = ''
      worker_processes auto;
      worker_rlimit_nofile 50000;
    '';

    upstreams = {
      "backend" = {
        servers."127.0.0.1:7171" = {
          max_fails = 1;
          fail_timeout = "2s";
        };
        extraConfig = ''
          zone upstreams 64k;
          keepalive 2;
        '';
      };
    };

    virtualHosts = {
      "www.updatecountdown.com" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://backend";
            recommendedProxySettings = true;
            proxyWebsockets = true;
            extraConfig = ''
              proxy_next_upstream error timeout http_500;
            '';
          };
        };
      };

      "updatecountdown.com" = {
        forceSSL = true;
        enableACME = true;
        globalRedirect = "www.updatecountdown.com";
      };
    };
  };
}
