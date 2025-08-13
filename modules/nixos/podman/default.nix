{ username, ... }: {
  users.users.${username} = {
    extraGroups = [ "podman" ];
    linger = true;
    autoSubUidGidRange = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    quadlet.enable = true;
  };
}
