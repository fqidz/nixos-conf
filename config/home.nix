{
  config,
  pkgs,
  inputs,
  ...
}:
let
  username = "faidz";
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./packages
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
      roboto-mono
      sops
      age
      gnupg
      python311
      ripgrep
      file
      btop
      gcc
      libgcc
      wget
      nix-tree
      fastfetch
      obsidian
      spicetify-cli
      feh
      anki
      jq
      socat
      pulseaudio
      acpi
    ];
    stateVersion = "24.05";
  };

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    desktopEntries = {
      syncthing = {
        name = "Syncthing";
        type = "Application";
        genericName = "Syncthing";
        exec = "xdg-open http://localhost:8384/";
        terminal = false;
        categories = [ "Application" "Network" ];
      };
      gvim = {
        name = "GVim";
        exec = "gvim";
        noDisplay = true;
      };
      vim = {
        name = "Vim";
        exec = "vim %F";
        noDisplay = true;
      };
      nvim = {
        name = "Neovim wrapper";
        exec = "nvim %F";
        noDisplay = true;
      };
      nixos-manual = {
        name = "NixOS Manual";
        exec = "nixos-help";
        noDisplay = true;
      };
      xterm = {
        name = "XTerm";
        exec = "xterm";
        noDisplay = true;
      };
      wpa_gui = {
        name = "wpa_gui";
        exec = "wpa_gui";
        noDisplay = true;
      };
    };
  };

  programs = {
    feh = {
      enable = true;
      keybindings = {
        prev_img = null;
        next_img = null;
      };
      buttons = {
        zoom_in = 4;
        zoom_out = 5;
      };
    };

    fastfetch = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    spicetify = {
      enable = true;
      theme = spicePkgs.themes.dribbblish;
      colorScheme = "rosepine";

      enabledExtensions = with spicePkgs.extensions; [
        adblock
      ];
    };
  };

  services = {
    syncthing = {
      enable = true;
      extraOptions = [
        "--no-default-folder"
        "--no-browser"
        "--config=${config.xdg.configHome}/syncthing"
        "--data=${config.xdg.dataHome}/syncthing"
      ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;
}
