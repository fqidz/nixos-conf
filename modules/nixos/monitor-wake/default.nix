{ pkgs, system, ... }:
{
  services.dbus.packages = [
    (derivation {
      inherit system;
      name = "monitor-wake-conf";
      src = ./monitor-wake.conf;
      builder = pkgs.writeShellScript "monitor-wake-conf-build" ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/dbus-1/system.d/
        ${pkgs.coreutils}/bin/cp $src $out/share/dbus-1/system.d/monitor-wake.conf
      '';
      outputs = [ "out" ];
    })
  ];
}
