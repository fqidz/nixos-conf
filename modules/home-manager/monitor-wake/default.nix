{ inputs, system, ... }:
{
  home.packages = [ inputs.monitor-wake.packages.${system}.default ];
}
