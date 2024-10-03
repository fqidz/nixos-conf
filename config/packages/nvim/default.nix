{ pkgs, ... }:
{
  home.packages = [
    # pkgs.neovim
    pkgs.nil
    pkgs.tree-sitter
    pkgs.lua-language-server
    pkgs.lua
    pkgs.luarocks
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.markdown-preview-nvim
    ];
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
}
