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
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    ANDROID_HOME = "$HOME/Android/Sdk";
    JAVA_HOME = "${pkgs.jdk17}";
  };
  home.sessionPath = [
    "$HOME/.opencode/bin"
    "$ANDROID_SDK_ROOT/platform-tools"
    "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
    "$ANDROID_SDK_ROOT/emulator"
    "$ANDROID_SDK_NIX/cmdline-tools/latest/bin"
    "$HOME/.pub-cache/bin"
  ];
  home.packages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.85";
    };
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#thinkpad";
      emulator = ''LD_LIBRARY_PATH="$ANDROID_SDK_ROOT/emulator/lib64:$ANDROID_SDK_ROOT/emulator/lib64/qt/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" command emulator'';
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
