{ config, pkgs, ... }:
{
  sops.secrets = {
    "samba-user-client" = {
      key = "client";
      sopsFile = ../../../secrets/samba.yaml;
    };
  };
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/storage" = {
    device = "//192.168.100.11/storage";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [
        "${automount_opts},credentials=${config.sops.secrets."samba-user-client".path},uid=1000,gid=100"
        "nofail"
      ];
  };
}
