{ pkgs, ... }:
let
  monitorWakeConf = pkgs.stdenv.mkDerivation {
    name = "monitor-wake-conf";
    phases = "buildPhase";
    src = ./monitor-wake.conf;

    buildPhase = ''
      mkdir -p $out/share/dbus-1/system.d/
      cp $src $out/share/dbus-1/system.d/monitor-wake.conf
    '';
  };
in
{
  services.dbus.packages = [ monitorWakeConf ];
}
