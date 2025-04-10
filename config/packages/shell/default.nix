{ pkgs, ... }:
let
  initExtraScript = pkgs.stdenv.mkDerivation {
    name = "init_extra";
    phases = "buildPhase";
    src = ./init_extra.sh;

    buildPhase = ''
      mkdir $out
      cp $src $out/init_extra.sh
      substituteInPlace "$out/init_extra.sh" \
        --replace-fail "feh " "${pkgs.feh}/bin/feh " \
        --replace-fail "jq" "${pkgs.jq}/bin/jq" \
        --replace-fail "sqlite3" "${pkgs.sqlite}/bin/sqlite3" \
        --replace-fail "yazi " "${pkgs.yazi}/bin/yazi "\
        --replace-fail '"fzf"' '"${pkgs.fzf}/bin/fzf"' \
        --replace-fail '"firefox"' '"${pkgs.firefox}/bin/firefox"' \
        --replace-fail "xdg-open" "${pkgs.xdg-utils}/bin/xdg-open" \
        --replace-fail "xdg-mime" "${pkgs.xdg-utils}/bin/xdg-mime" \
        --replace-fail "ueberzugpp " "${pkgs.ueberzugpp}/bin/ueberzugpp "
    '';
  };
in
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
        IWD_RTNL_DEBUG = "1";
        IWD_GENL_DEBUG = "1";
        IWD_DHCP_DEBUG = "debug";
        IWD_TLS_DEBUG = "1";
        IWD_WSC_DEBUG_KEYS = "1";
      };

      shellAliases = {
        nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default";
        nh-rebuild = "nh os switch -H default /etc/nixos";
        spotifyr = "spotify > /dev/null &!";
        nix-dev = "nix develop -c $SHELL";
        gitroot = "cd \"$(git rev-parse --show-toplevel)\"";
        rm = "printf \"Use the \\`trash\\` command instead. Do \\`%srm\\` if you really need to rm.\\n\" \"\\\\\"; false";
      };

      dirHashes = {
        nixconf = "/etc/nixos";
        uob = "$HOME/Projects/uob-works/";
      };

      initExtra = builtins.readFile "${initExtraScript}/init_extra.sh";
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = "$all$directory\n$character";
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
