{
  config,
  pkgs,
  lib,
  stylixColors,
  inputs,
  ...
}:

let
  palette = stylixColors;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
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
    glow
  ];
  programs.spicetify = {
    enable = true;
    enabledSnippets = with spicePkgs.snippets; [
      sonicDancing
    ];
  };
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
      flup = "nix flake update --flake \"$HOME/dotfiles\"";
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#thinkpad";
      emulator = ''LD_LIBRARY_PATH="$ANDROID_SDK_ROOT/emulator/lib64:$ANDROID_SDK_ROOT/emulator/lib64/qt/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" command emulator'';
    };
    initContent = ''
      alias g='git'

      alias gc='git clone'
      alias gcm='git commit -m'

      alias ga='git add'
      alias gaa='git add -A'
      alias gap='git add -p'

      alias gst='git status -sb'
      alias gd='git diff'
      alias gds='git diff --staged'

      alias gco='git checkout'
      alias gcb='git checkout -b'
      alias gsw='git switch'
      alias gswc='git switch -c'

      alias gl='git log --oneline --decorate --graph'
      alias gll='git log --oneline --decorate --graph --all'

      alias gpl='git pull --rebase --autostash'

      # oh-my-zsh's git plugin defines `gp` (git push); keep it unaliased.
      unalias gp 2>/dev/null
    '';
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
  services.mako = {
    enable = true;
    settings = {
      "app-name=Spotify" = {
        default-timeout = 3000;
        ignore-timeout = true;
      };
    };
  };

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
