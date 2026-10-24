{ pkgs, ... }:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = [
    pkgs.android-tools
    pkgs.android-studio
  ];
}
