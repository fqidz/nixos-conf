{ pkgs, ... }:
{
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "faidz.arante@gmail.com";
      certs = {
        "uobwiki.com" = {
          email = "admin@uobwiki.com";
          webroot = "/var/lib/acme/acme-challenge";
          group = "nginx";
          extraDomainNames = [
            "en.uobwiki.com"
            "ar.uobwiki.com"
            "files.uobwiki.com"
          ];
        };
      };
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

    virtualHosts =
    let
      redirect = targetUrl: {
        globalRedirect = targetUrl;
        forceSSL = true;
        enableACME = true;
      };
    in
    {
      "updatecountdown.com" = {
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

      "www.updatecountdown.com" = redirect "updatecountdown.com";

      # Accept all subdomains
      # https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name
      ".uobwiki.com" = {
        forceSSL = true;
        # enableACME = true;
        useACMEHost = "uobwiki.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          extraConfig = ''
            proxy_set_header Host $host;

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto https;
          '';
        };
      };
    };
  };
}
