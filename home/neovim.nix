{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # LSP Server + Formatter
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp

      # Treesitter (Syntax Highlighting)
      nvim-treesitter.withAllGrammars
    ];

    extraLuaConfig = builtins.readFile ../nvim/init.lua;
  };
}
