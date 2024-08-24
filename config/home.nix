{ config, pkgs, inputs, lib, ... }: let
  username = "faidz";
in {
  imports = [
    ./packages
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
      # settings = {
      #   mainBar = {
      #     output = [ "eDP-1" ];
      #     layer = "top";
      #     position = "top";
      #   };
      # };
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
        # line_break.disabled = true;
      };
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


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   "rose-pine.toml" = {
  #     source = pkgs.fetchFromGitHub {
  #       owner = "rose-pine";
  #       repo = "alacritty";
  #     };
  #     target = ".config/alacritty/";
  #   }
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/faidz/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  #   # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
