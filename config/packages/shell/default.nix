{ pkgs, ... }:
{
  home.packages = [
    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.starship
  ];

  programs = {
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
          ls = "eza";
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
  };
}
