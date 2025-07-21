{ pkgs, ... }:
{
  security = {
    acme = {
      acceptTerms = true;
      certs."updatecountdown.com".email = "faidz.arante@gmail.com";
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
    # appendConfig = "";
    enableReload = true;

    virtualHosts = {
      "updatecountdown.com" = {
        forceSSL = true;
        enableACME = true;

        serverAliases = [ "www.updatecountdown.com" ];
        locations."/" = {
          proxyPass = "http://[::1]:8080";
          # root = "/var/www";
        };
      };
    };
  };
}
