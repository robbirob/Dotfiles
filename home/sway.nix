{
  config,
  pkgs,
  lib,
  stylixColors,
  ...
}:

let
  palette = stylixColors;
  swaylockPkg = pkgs.swaylock-effects;
  swaylockCmd = "${swaylockPkg}/bin/swaylock -f --color ${palette.base00} --text-color ${palette.base05} --text-ver-color ${palette.base0D} --text-wrong-color ${palette.base08} --ring-color ${palette.base0D} --ring-ver-color ${palette.base0D} --ring-wrong-color ${palette.base08} --key-hl-color ${palette.base0B} --inside-color ${palette.base00} --inside-ver-color ${palette.base00} --inside-wrong-color ${palette.base00} --line-color ${palette.base00} --line-ver-color ${palette.base0D} --line-wrong-color ${palette.base08} --separator-color ${palette.base00} --indicator --indicator-idle-visible --clock --timestr \"%H:%M\" --datestr \"%a %d %b\"";
in
{
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
        focus_wrapping yes
        exec waybar
        exec ${pkgs.swayidle}/bin/swayidle -w \
          timeout 300 '${swaylockCmd}' \
          timeout 600 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"' \
          before-sleep '${swaylockCmd}'

        # Keep Spotify on workspace 10.
        assign [class="Spotify"] workspace number 10
        workspace 1; exec ${pkgs.kitty}/bin/kitty
        workspace 2; exec ${pkgs.firefox}/bin/firefox
        workspace 10; exec spotify
        workspace 1

      # ornicar border settings
      default_border pixel 1
      hide_edge_borders both
      titlebar_padding 1 1
    '';
    config = rec {
      fonts = lib.mkForce {
        names = [ "DejaVu Sans" ];
        size = 0.5;
      };
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.bemenu}/bin/bemenu-run";

      seat = {
        "*" = {
          # timeout in milliseconds as a string
          hide_cursor = "2000";
        };
      };

      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
        };
      };
      colors =
        let
          text = "#${palette.base04}";
          urgent = "#${palette.base09}";
          focused = "#${palette.base04}";
          unfocused = "#${palette.base00}";
          background = "#${palette.base00}";
          indicator = "#${palette.base0C}";
        in
        lib.mkForce {
          inherit background;
          urgent = {
            inherit background indicator text;
            border = urgent;
            childBorder = urgent;
          };
          focused = {
            border = focused;
            childBorder = focused;
            background = focused;
            indicator = focused;
            text = focused;
          };
          focusedInactive = {
            inherit background indicator text;
            border = unfocused;
            childBorder = unfocused;
          };
          unfocused = {
            inherit background indicator text;
            border = unfocused;
            childBorder = unfocused;
          };
          placeholder = {
            inherit background indicator text;
            border = unfocused;
            childBorder = unfocused;
          };
        };
      bars = [ ];
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+e" = "exec swaymsg exit";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Tab" = "focus next";
        "${modifier}+Shift+Tab" = "focus prev";
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
      };
    };
  };

  stylix.targets.sway.enable = true;
}
