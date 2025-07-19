{ ... }:
{
  programs.feh = {
    enable = true;
    # Unbind scroll wheel
    keybindings = {
      prev_img = null;
      next_img = null;
    };
    # Bind scroll wheel to zoom
    buttons = {
      zoom_in = 4;
      zoom_out = 5;
    };
  };
}
