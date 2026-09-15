{ config, ... }:
let
  ingress = import ./ingress.nix;
in
{
  sops.secrets = {
    "cloudflared-key" = {
      key = "key";
      sopsFile = ../../../secrets/cloudflared.yaml;
    };
    "cloudflared-cred" = {
      key = "cred";
      sopsFile = ../../../secrets/cloudflared.yaml;
    };
  };
  services.cloudflared = {
    enable = true;
    tunnels = {
      "60d43286-97c8-4ecb-abd4-06630f86466f" = {
        credentialsFile = "${config.sops.secrets."cloudflared-cred".path}";
        edgeIPVersion = "6";
        inherit ingress;
        # certificateFile = "${config.sops.secrets."cloudflared-key".path}";
        default = "http_status:404";
      };
    };
  };
}
