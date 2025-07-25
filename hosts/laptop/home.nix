{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/home-manager/full.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      # Important for sops
      age
      gnupg
      sops

      # Compilers
      gcc
      libgcc
      python311

      # CLI tools
      acpi
      bc
      btop
      file
      jq
      nix-tree
      nodejs-slim
      powertop
      pulseaudio
      ripgrep
      socat
      trash-cli
      wget

      # Programs (that don't need their own config file)
      (mpv.override { scripts = [ mpvScripts.mpris ]; })
      obsidian
      sqlite
      weechat
      wireshark
    ];
    stateVersion = "24.05";
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
