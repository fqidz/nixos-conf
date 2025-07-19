{ ... }:
{
  xdg = {
    enable = true;
    # /etc/profiles/per-user/faidz/share/applications/
    desktopEntries = {
      syncthing = {
        name = "Syncthing";
        type = "Application";
        genericName = "Syncthing";
        exec = "xdg-open http://localhost:8384/";
        terminal = false;
        categories = [
          "Application"
          "Network"
        ];
      };
      gvim = {
        name = "GVim";
        exec = "gvim";
        noDisplay = true;
      };
      vim = {
        name = "Vim";
        exec = "vim %F";
        noDisplay = true;
      };
      nvim = {
        name = "Neovim wrapper";
        exec = "nvim %F";
        noDisplay = true;
      };
      nixos-manual = {
        name = "NixOS Manual";
        exec = "nixos-help";
        noDisplay = true;
      };
      xterm = {
        name = "XTerm";
        exec = "xterm";
        noDisplay = true;
      };
      wpa_gui = {
        name = "wpa_gui";
        exec = "wpa_gui";
        noDisplay = true;
      };
      btop = {
        name = "btop++";
        exec = "btop";
        noDisplay = true;
      };
      books = {
        # books function found in 'config/packages/shell/init_extra.sh'
        name = "Open books";
        exec = ''alacritty --option "window.opacity=0.9" --title open-books -e zsh -c "source /home/faidz/.zshrc && books"'';
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "text/html" = "firefox.desktop";
      };
    };
  };

}
