{ pkgs, ... }:
{
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "faidz.arante@gmail.com";
      # certs."updatecountdown.com" = {
      #   email = "faidz.arante@gmail.com";
      # };
    };
  };
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    package = pkgs.nginxMainline;
    enableReload = true;

    virtualHosts = {
      "www.updatecountdown.com" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };
        # locations."/websocket/" = {
        #   proxyPass = "http://127.0.0.1:8080";
        #   recommendedProxySettings = true;
        #   proxyWebsockets = true;
        # };
      };

      "updatecountdown.com" = {
        forceSSL = true;
        enableACME = true;
        globalRedirect = "www.updatecountdown.com";
      };
    };
  };
}
