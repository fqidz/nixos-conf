{ pkgs, config, ... }:
{
  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        extended = true;
        # size/save has limit of LONG_MAX
        # https://www.zsh.org/mla/users/2013/msg00691.html
        # https://github.com/zsh-users/zsh/blob/3cd363c8804a4569e601f4486a0001b1de14811f/Src/hist.c#L108
        save = 2147483647;
        size = 2147483647;
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };

      # sessionVariables = {
      #   IWD_RTNL_DEBUG = "1";
      #   IWD_GENL_DEBUG = "1";
      #   IWD_DHCP_DEBUG = "debug";
      #   IWD_TLS_DEBUG = "1";
      #   IWD_WSC_DEBUG_KEYS = "1";
      # };

      shellAliases = {
        gitroot = "cd \"$(git rev-parse --show-toplevel)\"";
        rm = "printf \"Use the \\`trash\\` command instead. Do \\`%srm\\` if you really need to rm.\\n\" \"\\\\\"; false";
      };

      dirHashes = {
        nixconf = "/etc/nixos";
      };

      initContent = builtins.readFile ./init_extra_vps.sh;
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
        c.commands = [
          [
            "clang"
            "--version"
          ]
        ];
      };
    };
  };
}
