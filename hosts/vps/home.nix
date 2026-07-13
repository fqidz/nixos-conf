{ pkgs, username, ... }:
{
  imports = [
    ../../modules/home-manager/shell/vps.nix
    ../../modules/home-manager/git/vps.nix
    ../../modules/home-manager/podman-quadlet
    ../../modules/home-manager/podman-quadlet/containers/timescaledb.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      # CLI tools
      btop
      file
      nix-tree
      ripgrep
      trash-cli
      wget
      nginxMainline
    ];
    stateVersion = "24.05";
  };
}
