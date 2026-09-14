{ config, ... }:
{
  sops.secrets."wg-key" = {
    key = "laptop";
    sopsFile = ../../../secrets/wireguard.yaml;
    owner = "root";
    group = "systemd-network";
    mode = "0640";
  };

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;

    networks."wg0" = {
      matchConfig.Name = "wg0";
      # address = [ "192.168.100.0/24" ];
    };

    netdevs."wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.sops.secrets."wg-key".path;
        RouteTable = "main";
        FirewallMark = 17;
      };
      # wireguardPeers = [
      #   {
      #     PublicKey = "A/S+PbWA4Yyd2jJk5ALtgRlDg4pt5ICTvhOyM6CeyWc=";
      #     AllowedIPs = [ "192.168.100.0/24" ];
      #     # TODO: point to public ip (ofc use sops)
      #     Endpoint = "192.168.100.11:51820";
      #   }
      # ];
    };
  };
}
