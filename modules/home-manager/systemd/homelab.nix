{ pkgs, config, username, ... }:
{
  sops.secrets = {
    "duckdns" = {
      key = "secrets.env";
      sopsFile = ../../../secrets/duckdns.yaml;
    };
  };

  systemd.user = {
    enable = true;
    timers."duckdns" = {
      Timer = {
        OnCalendar = "*:0/5";
        Unit = "duckdns.service";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
    services."duckdns" = {
      Service = {
        ExecStart = [ ''${pkgs.coreutils}/bin/echo url="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=" | ${pkgs.lib.getExe pkgs.curl} -k -o ~/duckdns/duck.log -K -'' ];
        EnvironmentFile = config.sops.secrets."duckdns".path;
        Type = "oneshot";
        User = username;
      };
    };
  };
}
