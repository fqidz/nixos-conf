{ config, pkgs, lib, inputs, ... }:
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
      fzf
      tree
      wl-clipboard
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
      alacritty
      neovim
      fastfetch
      ntfs3g
      obsidian
      spicetify-cli
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

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fd = {
      enable = true;
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

  systemd.user.enable = true;

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

  home.file = {
    ".config/alacritty" = {
      enable = true;
      source = ../configFiles/alacritty;
    };
    ".config/wallpapers" = {
      enable = true;
      source = ../configFiles/wallpapers;
    };
    ".local/share/icons" = {
      enable = true;
      source = ../configFiles/hyprcursors;
    };
    ".config/direnv/direnvrc" = {
      enable = true;
      # https://github.com/direnv/direnv/wiki/Customizing-cache-location#human-readable-directories
      # make nix-direnv use ~/.cache/direnv/profiles/ to save the cache
      source = ../configFiles/direnv/direnvrc;
      };
  };

  xdg.desktopEntries = {
    syncthing = {
      name = "Syncthing";
      type = "Application";
      genericName = "Syncthing";
      exec = "syncthing";
      terminal = false;
      categories = [ "Application" "Network" ];
    };
  };

  nixpkgs.config = { allowUnfree = true; };

  programs.home-manager.enable = true;
}
