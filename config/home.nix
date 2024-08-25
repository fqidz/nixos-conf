{ config, pkgs, inputs, lib, spicetify-nix, unstable, ... }:
let
  username = "faidz";
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [
    ./packages
    spicetify-nix.homeManagerModule
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
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
      git
      wget
      alacritty
      oh-my-zsh
      neovim
      waybar
      swaybg
      fastfetch
      ntfs3g
      spotify
      sops
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

    spicetify = {
      enable = true;
      theme = spicePkgs.themes.Dribbblish;
      colorScheme = "rosepine";
      spotifyPackage = unstable.spotify;
      # enabledExtensions = with spicePkgs.extensions; [
      #   fullAppDisplay
      #   shuffle
      #   hidePodcasts
      # ];
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

  systemd.user.tmpfiles.rules = [
    "d /home/${username}/.config/sops/age 0700 ${username} - - -"
  ];

  sops = {
    age.keyFile = "/home/faidz/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  # sops = {
  #   secrets = {
  #     test_key = {
  #       path = "%r/test.txt";
  #     };
  #   };
  # };
  #
  # systemd.user.services = {
  #   mbsync.Unit.After = [ "sops-nix.service "];
  #   service-name = {
  #     Unit = {
  #       Description = "spotifyd service";
  #     };
  #
  #     Service = {
  #       ExecStart = "spotifyd --username fqidz --password $(cat $XDG_RUNTIME_DIR/test.txt)";
  #       WorkingDirectory = /home/fqidz/spotifyd_service;
  #     };
  #   };
  # };

  nixpkgs.config = { allowUnfree = true; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
