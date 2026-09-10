{ pkgs, config, ... }:
{
  home.packages = [ pkgs.ostui ];

  sops.secrets = {
    "ostui_username" = {
      key = "username";
      sopsFile = ../../../secrets/ostui.yaml;
    };
    "ostui_password" = {
      key = "password";
      sopsFile = ../../../secrets/ostui.yaml;
    };
  };

  xdg.configFile."ostui/config" = {
    source = (pkgs.formats.toml { }).generate "config" {
      server = {
        host = "http://192.168.100.11:4533";
        scrobble = true;
      };
    };
  };

  # load auth from environment variables
  home.sessionVariables = {
    OSTUI_USERNAME = "$(cat ${config.sops.secrets."ostui_username".path})";
    OSTUI_PASSWORD = "$(cat ${config.sops.secrets."ostui_password".path})";
  };

  programs.zsh.shellAliases = {
    ostui = "ostui --mpris auth --username \"$OSTUI_USERNAME\" --password \"$OSTUI_PASSWORD\"";
  };
}
