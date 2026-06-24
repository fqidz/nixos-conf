{ username, ... }:
{
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

  # OpenSearch settings (used for mediawiki)
  # https://docs.opensearch.org/1.3/install-and-configure/install-opensearch/index/#important-settings
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  # Fix podman Error: crun: setrlimit `RLIMIT_NOFILE`: Operation not permitted: OCI permission denied
  # (if the error happens, you have to reboot after putting these settings and delete the image to fix it)
  # https://github.com/fedora-silverblue/issue-tracker/issues/460
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nproc";
      type = "-";
      value = "65536";
    }
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];
  # Don't know why but `nofile` doesn't work with `security.pam.loginLimits`
  # and only works with this:
  systemd.user.settings.Manager = {
    DefaultLimitNOFILE = 131072;
  };

  # Fix podman quadlet taking so long to start:
  # (podman-user-wait-network-online.service: Failed with result 'timeout'.)
  # https://github.com/podman-container-tools/podman/issues/24796#issuecomment-3300278308
  systemd.targets.network-online.wantedBy = [ "multi-user.target" ];
}
