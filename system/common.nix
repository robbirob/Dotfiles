{ pkgs, ... }:

let
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "latest";
    platformToolsVersion = "35.0.2";
    buildToolsVersions = [ "28.0.3" ];
    platformVersions = [ "36" ];
    includeEmulator = true;
    includeSystemImages = false;
  };
  androidSdk = androidPkgs.androidsdk;
in
{
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  security.sudo.extraConfig = ''
    Defaults env_keep += "EDITOR VISUAL SUDO_EDITOR"
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    keyMap = "de-latin1-nodeadkeys";
  };

  hardware.graphics.enable = true;
  services.libinput.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.logind.settings.Login = {
    HandleSuspendKey = "poweroff";
    HandleSuspendKeyLongPress = "poweroff";
    SuspendKeyIgnoreInhibited = "no";
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sway
    glib
    swaylock-effects
    swayidle
    waybar
    mako
    kitty
    bemenu
    xdg-utils
    grim
    slurp
    wl-clipboard
    brightnessctl
    tuigreet
    flutter
    android-tools
    jdk17
    androidSdk
  ];

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  stylix.enable = true;
  stylix.image = ../wallpaper/pexels-lum3n-44775-167699.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.fonts = {
    sansSerif = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
    serif = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  programs.vim.enable = true;
  programs.zsh.enable = true;
  programs.adb.enable = true;
  environment.variables = {
    ANDROID_SDK_NIX = "${androidSdk}/libexec/android-sdk";
    SUDO_EDITOR = "nvim";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glibc
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXi
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXmu
    xorg.libxcb
    xorg.libSM
    xorg.libICE
    libGL
    alsa-lib
    libpulseaudio
    libpng
    nss
    nspr
    expat
    libdrm
    xorg.libxkbfile
    libbsd
    libxkbcommon
    fontconfig
    freetype
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    pkgs."xcb-util-cursor"
  ];

  users.users.rob = {
    isNormalUser = true;
    description = "Robert";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "adbusers"
      "kvm"
    ];
  };
}
