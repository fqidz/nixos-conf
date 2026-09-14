{ config, ... }:
{
  sops.secrets."wg-key" = {
    key = "homelab";
    sopsFile = ../../../secrets/wireguard.yaml;
    owner = "root";
    group = "systemd-network";
    mode = "0640";
  };

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    useNetworkd = true;
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp1s0";
      internalInterfaces = [ "wg0" ];
    };
  };

  systemd.network = {
    enable = true;

    networks."wg0" = {
      matchConfig.Name = "wg0";
      address = [ "0.0.0.0/0" ];
      networkConfig = {
        # do not use IPMasquerade,
        # unnecessary, causes problems with host ipv6
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
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
      wireguardPeers = [
        {
          PublicKey = "ff9LSuXOu3AaXoVCqhM4FQwYLwQcNG1JpmdQ5/l1lxA=";
          AllowedIPs = [ "0.0.0.0/0" ];
        }
      ];
    };
  };
}
