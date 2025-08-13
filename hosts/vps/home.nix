{ pkgs, username, ... }:
{
  imports = [
    ../../modules/home-manager/headless.nix
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
      neovim
      nginxMainline
    ];
    stateVersion = "24.05";
  };
}
