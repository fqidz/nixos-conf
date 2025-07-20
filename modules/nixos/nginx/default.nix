{ pkgs, ... }:
{
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
  };
}
