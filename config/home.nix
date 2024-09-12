{ config, pkgs, lib, inputs, ... }:
let
  username = "faidz";
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./packages
  ];
  
  gtk = {
    enable = true;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 28;
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
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
      git
      brightnessctl
      hypridle
      hyprlock
      hyprpaper
      hyprcursor
      hyprshot
      libnotify
      playerctl
      tofi
      cliphist
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

    fd = {
      enable = true;
    };

    waybar = {
      enable = true;
      systemd.enable = true;
    };

    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          no_fade_out = true;
          immediate_render = true;
        };

        background = {
          monitor = "";
          color = "rgba(25, 23, 36, 1.0)";
          blur_passes = 0;
        };

        input-field = {
          monitor = "";
          size = "1500, 200";
          outline_thickness = -1;
          dots_size = 0.33;
          dots_spacing = 0.25;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(0, 0, 0, 0.0)";
          inner_color = "rgba(0, 0, 0, 0.0)";
          font_color = "rgb(224, 222, 244)";
          fade_on_empty = false;
          placeholder_text = "";
          fail_color = "rgb(235, 111, 146)";
          fail_text = "";

          position = "0, 0";
          halign = "center";
          valign = "center";
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
          nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default";
          spotifyr = "spotify > /dev/null &!";
          nix-dev = "nix develop -c $SHELL";
          gitroot = "cd \"$(git rev-parse --show-toplevel)\"";
      };

      dirHashes = {
        nixconf = "/etc/nixos";
      };

      initExtra = ''
        bindkey '^ ' autosuggest-accept
        typeset -A ZSH_HIGHLIGHT_STYLES
        ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta,bold'
      '';
    };

    fastfetch = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = "$all$directory\n$character" ;
        character = {
          success_symbol = "[❯](purple bold)";
          error_symbol = "[❯](red bold)";
        };
        cmd_duration.disabled = true;
        directory = {
          truncation_length = 0;
          read_only = " ";
        };
        git_status = {
          deleted = " ";
        };
        line_break.disabled = true;
      };
    };

    firefox = {
      enable = true;
    };

    tofi = {
      enable = true;
      settings = {
        font = "${(pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; }).outPath}/share/fonts/truetype/NerdFonts/RobotoMonoNerdFont-Medium.ttf";
        font-size = 20;
        width = 800;
        height = 540;
        background-color = "#191724e6";
        text-color = "#e0def4";
        selection-color = "#9ccfd8";
        prompt-text = "\"\"";
        num-results = 5;
        result-spacing = 10;
        outline-width = 0;
        border-width = 1;
        border-color = "#c4a7e7";
        corner-radius = 10;
        padding-top = 110;
        padding-bottom = 20;
        padding-right = 110;
        padding-left = 110;
        clip-to-padding = true;
        hide-cursor = true;
        text-cursor = true;
        # matching-algorithm = "fuzzy"; # not working
        fuzzy-match = true;
      };
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
          lock_cmd = "hyprlock";
          before_sleep_cmd = "loginctl lock-session";
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

    dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          width = "(200, 300)";
          height = "(100, 200)";
          origin = "top-right";
          offset = "30x100";
          icon_corner_radius = 10;
          corner_radius = 15;
          font = "Roboto Mono";
        };
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
    ".config/wallpapers" = {
      enable = true;
      source = ../configFiles/wallpapers;
    };
    ".local/share/icons" = {
      enable = true;
      source = ../configFiles/hyprcursors;
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
