{ config, pkgs, lib, stylixColors, ... }:

let
  palette = stylixColors;
in {
  imports = [
    ./firefox.nix
    ./git.nix
    ./neovim.nix
    ./sway.nix
    ./waybar.nix
  ];

  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.sessionPath = [ "$HOME/.opencode/bin" ];
  home.packages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];
  programs.kitty.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#thinkpad";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "history"
        "extract"
        "colored-man-pages"
      ];
    };
  };
  services.mako.enable = true;

  stylix.targets.neovim.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.firefox.profileNames = [ "rob" ];
}
