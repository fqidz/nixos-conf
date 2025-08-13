{ config, ... }: {
  imports = [
    ../default.nix
    ../../sops
  ];

  # https://dl.thalheim.io/
  sops.secrets = {
    "db.env".sopsFile = ../../../../secrets/db.yaml;
  };

  # https://seiarotg.github.io/quadlet-nix/home-manager-options.html
  virtualisation.quadlet.containers = {
    timescaledb = {
      autoStart = true;
      serviceConfig = {
          RestartSec = "10";
          Restart = "always";
      };
      # https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#container-units-container
      containerConfig = {
          image = "docker.io/timescale/timescaledb:latest-pg17";
          name = "timescaledb";
          publishPorts = [ "127.0.0.1:5432:5432" ];
          userns = "keep-id";
          healthCmd = "pg_isready -U postgres";
          volumes = [ "${config.home.homeDirectory}/postgresql/data:/var/lib/postgresql/data" ];
          # postgres user & password
          environmentFiles = [ config.sops.secrets."db.env".path ];
      };
    };
  };
}
