{ config, pkgs, lib, ... }:
let
  username = "faidz";
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
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
      gcc
      libgcc
      lua-language-server
      nil
      git
      wget
      firefox
      alacritty
      oh-my-zsh
      neovim
      waybar
      swaybg
      fastfetch
      ntfs3g
      spotify
      obsidian
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

    waybar = {
      enable = true;
    };

    zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
          hypr-logout = "hyprctl dispatch exit";
          nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default";
          spotifyr = "spotify > /dev/null &!";
      };

      dirHashes = {
        nixconf = "/etc/nixos";
      };

      initExtra = ''
        bindkey '^ ' autosuggest-accept
      '';
    };

    fastfetch = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$all"
          "$directory"
          "$character"
        ];
        cmd_duration.disabled = true;
        directory.truncation_symbol = ".../";
      };
    };

    firefox = {
      enable = true;
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

  home.file = {
    ".config/waybar" = {
      enable = true;
      source = ../configFiles/waybar;
    };
    ".config/alacritty" = {
      enable = true;
      source = ../configFiles/alacritty;
    };
  };

  nixpkgs.config = { allowUnfree = true; };

  programs.home-manager.enable = true;
}
