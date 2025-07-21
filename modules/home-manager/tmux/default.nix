{ ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    # shell = "${lib.getBin pkgs.zsh}";
    terminal = "screen-256color";
  };
}
