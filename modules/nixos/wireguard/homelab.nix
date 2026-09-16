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
      address = [ "10.20.30.1/24" "fd00::1/64" ];
      networkConfig = {
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
        # RouteTable = "main";
        FirewallMark = 17;
      };
      wireguardPeers = [
        {
          PublicKey = "ff9LSuXOu3AaXoVCqhM4FQwYLwQcNG1JpmdQ5/l1lxA=";
          AllowedIPs = [ "10.20.30.2/32" "fd00::2/128" ];
        }
        {
          PublicKey = "LZUBjJctLqzQoUyuX2KJcWyWhLgSc1ntq3IOOkEn8wM=";
          AllowedIPs = [ "10.20.30.3/32" "fd00::3/128" ];
        }
      ];
    };
  };
}
