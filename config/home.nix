{
  config,
  pkgs,
  lib,
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
    sessionVariables = {
      EDITOR = "nvim";
      XDG_CACHE_HOME = "$HOME/.cache";
      # XDG_CONFIG_DIRS = "/etc/xdg";
      XDG_CONFIG_HOME = "$HOME/.config";
      # XDG_DATA_DIRS = "/usr/local/share/:/usr/share/";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
      roboto-mono
      python311
      tree-sitter
      ripgrep
      file
      gcc
      libgcc
      lua-language-server
      luarocks
      nil
      sops
      age
      gnupg
      git
      wget
      firefox
      nix-tree
      wirelesstools
      wpa_supplicant_gui
      neovim
      fastfetch
      ntfs3g
      obsidian
      spicetify-cli
      feh
      ueberzugpp
    ];
    stateVersion = "24.05";
  };

  fonts.fontconfig.enable = true;

  programs = {
    git = {
      enable = true;
      userName = "fqidz";
      userEmail = "meowthful127@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

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

  # xdg.desktopEntries = {
  #   syncthing = {
  #     name = "Syncthing";
  #     type = "Application";
  #     genericName = "Syncthing";
  #     exec = "syncthing";
  #     terminal = false;
  #     categories = [ "Application" "Network" ];
  #   };
  # };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;
}
