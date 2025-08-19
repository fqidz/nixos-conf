{ pkgs, ... }:
{
  home.packages = [
    pkgs.tree-sitter
    pkgs.lua-language-server
    pkgs.vscode-langservers-extracted
    pkgs.lua
    pkgs.luarocks
    pkgs.marksman
    pkgs.texpresso
  ];

  programs.neovim = {
    enable = true;
    # not working idk why
    # defaultEditor = true;

    # viAlias = true;
    # vimAlias = true;
    # plugins = [
    #
    # ];
  };

  # This symlinks the plugin into a directory that lazy.nvim can access
  # and then just tell lazy.nvim to load the plugin from this directory
  # instead of pulling it from github:
  #
  #   {
  #     "iamcco/markdown-preview.nvim",
  #     dir = "~/.local/share/nvim/nix/markdown-preview-nvim/",
  #     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  #     ft = { "markdown" },
  #     build = function() vim.fn["mkdp#util#install"]() end,
  #   }
  home.file.".local/share/nvim/nix/markdown-preview-nvim/" = {
    source = pkgs.vimPlugins.markdown-preview-nvim;
    recursive = true;
  };

  home.file.".local/share/nvim/nix/texpresso-vim/" = {
    source = pkgs.vimPlugins.texpresso-vim;
    recursive = true;
  };
}
