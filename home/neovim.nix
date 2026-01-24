{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    neovim
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

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
