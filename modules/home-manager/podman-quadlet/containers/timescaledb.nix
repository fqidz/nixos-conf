{ config, ... }: {
  imports = [
    ../default.nix
    ../../sops
  ];

  # https://dl.thalheim.io/
  sops.secrets = {
    "db.env".sopsFile = ../../../../secrets/db.yaml;
    "pguser".sopsFile = ../../../../secrets/db.yaml;
    "pgpassword".sopsFile = ../../../../secrets/db.yaml;
    "pghost".sopsFile = ../../../../secrets/db.yaml;
    "pgport".sopsFile = ../../../../secrets/db.yaml;
    "pgdatabase".sopsFile = ../../../../secrets/db.yaml;
  };

  sops.templates."pguser".content = "${config.sops.placeholder."pguser"}";
  sops.templates."pgpassword".content = "${config.sops.placeholder."pgpassword"}";
  sops.templates."pghost".content = "${config.sops.placeholder."pghost"}";
  sops.templates."pgport".content = "${config.sops.placeholder."pgport"}";
  sops.templates."pgdatabase".content = "${config.sops.placeholder."pgdatabase"}";

  home.sessionVariables = {
    PGUSER = "$(cat ${config.sops.templates."pguser".path})";
    PGPASSWORD = "$(cat ${config.sops.templates."pgpassword".path})";
    PGHOST = "$(cat ${config.sops.templates."pghost".path})";
    PGPORT = "$(cat ${config.sops.templates."pgport".path})";
    PGDATABASE = "$(cat ${config.sops.templates."pgdatabase".path})";
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
