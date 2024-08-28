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
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
      python311
      tree-sitter
      ripgrep
      wl-clipboard
      gcc
      libgcc
      lua-language-server
      nil
      git
      brightnessctl
      hypridle
      hyprpaper
      playerctl
      wget
      firefox
      alacritty
      oh-my-zsh
      neovim
      waybar
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

    waybar = {
      enable = true;
      systemd.enable = true;
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

    hyprpaper = {
      enable = true;
      settings = {
        ipc = true;
        splash = false;
        preload = [
          "${config.xdg.configHome}/wallpapers/rose-pine-abstract.png"
        ];
        wallpaper = [
          ", ${config.xdg.configHome}/wallpapers/rose-pine-abstract.png"
        ];
      };
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 75%-";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 280;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 300;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    playerctld = {
      enable = true;
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
    ".config/wallpapers" = {
      enable = true;
      source = ../configFiles/wallpapers;
    };
  };

  nixpkgs.config = { allowUnfree = true; };

  programs.home-manager.enable = true;
}
