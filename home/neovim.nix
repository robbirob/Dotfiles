{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # LSP servers, formatters, and linters
    extraPackages = with pkgs; [
      black
      google-java-format
      jdk25
      jdt-language-server
      lua-language-server
      nodejs
      nodePackages.eslint_d
      nodePackages.prettier
      nodePackages.typescript
      nixd
      nixfmt-rfc-style
      pyright
      ruff
      stylua
      vtsls
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp

      # Treesitter (Syntax Highlighting)
      nvim-treesitter.withAllGrammars

      # Formatting and linting
      conform-nvim
      nvim-lint
    ];

    extraLuaConfig = builtins.readFile ../nvim/init.lua;
  };
}
