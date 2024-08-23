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

    alacritty = {
      enable = true;
      settings = {
        import = [ "${config.xdg.configHome}/alacritty/rose-pine.toml" ];

        font = {
          size = 13.0;

          normal = {
            family = "RobotoMono Nerd Font";
          };

          bold = {
            family = "RobotoMono Nerd Font";
            style = "Medium";
          };

          italic = {
            family = "RobotoMono Nerd Font";
            style = "Italic";
          };

          bold_italic = {
            family = "RobotoMono Nerd Font";
            style = "MediumItalic";
          };
        };

        window = {
          decorations = "None";
          opacity = 0.8;
          padding = {
            x = 10;
            y = 5;
          };
        };

      };
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
        line_break.disabled = true;
      };
    };

  };

  # todo
  home.activation.install-rose-pine-alacritty-theme = lib.hm.dag.entryAfter [ "writeBoundary" ]
   ''
   $DRY_RUN_CMD ${lib.getExe pkgs.wget} $VERBOSE_ARG \
   "https://raw.githubusercontent.com/rose-pine/alacritty/main/dist/rose-pine.toml" \
   -P "${config.xdg.configHome}/alacritty/"
   '';

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
