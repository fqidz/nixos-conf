{ pkgs, username, ... }:
{
  imports = [
    ../../modules/home-manager/direnv
    ../../modules/home-manager/eza
    ../../modules/home-manager/fzf
    ../../modules/home-manager/git
    ../../modules/home-manager/git/homelab.nix
    ../../modules/home-manager/gnupg
    ../../modules/home-manager/shell/homelab.nix
    ../../modules/home-manager/systemd
    ../../modules/home-manager/tmux
    ../../modules/home-manager/yazi/homelab.nix
    ../../modules/home-manager/ssh
    ../../modules/home-manager/ssh/homelab.nix
    # ../../modules/home-manager/podman-quadlet
    # ../../modules/home-manager/podman-quadlet/containers/timescaledb.nix
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
      # nginxMainline
    ];
    stateVersion = "26.05";
  };
}
