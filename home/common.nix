{
  config,
  pkgs,
  lib,
  stylixColors,
  ...
}:

let
  palette = stylixColors;
in
{
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
      vi = "nvim";
      vim = "nvim";
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
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".addKeysToAgent = "yes";
  };
  services.ssh-agent.enable = true;
  services.mako.enable = true;

  systemd.user.services.ssh-add = {
    Unit = {
      Description = "Add SSH key to agent";
      After = [ "ssh-agent.service" ];
      Requires = [ "ssh-agent.service" ];
    };
    Service = {
      Type = "oneshot";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
      ExecStart = "${pkgs.openssh}/bin/ssh-add %h/.ssh/id_ed25519";
    };
    Install.WantedBy = [ "default.target" ];
  };

  stylix.targets.neovim.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.firefox.profileNames = [ "rob" ];
}
