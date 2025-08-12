{ username, ... }: {
  users.users.${username} = {
    extraGroups = [ "podman" ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
