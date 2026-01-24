{ pkgs, stylixColors, ... }:

let
  palette = stylixColors;
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "idle_inhibitor"
          "temperature"
          "custom/stralsund-temp"
          "memory"
          "network"
          "pulseaudio"
          "battery"
          "clock#local"
          "tray"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          window-rewrite = { };
        };
        "sway/mode" = {
          format = " {}";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        "clock#local" = {
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = "{:%Y-%m-%d}";
        };
        memory = {
          format = "  {percentage}%";
          states = {
            warning = 70;
            critical = 85;
          };
        };
        temperature = {
          format = "  {temperatureC}°";
          critical-threshold = 80;
          interval = 2;
        };
        "custom/stralsund-temp" = {
          exec = ''
            ${pkgs.bash}/bin/bash -lc "output=\$(${pkgs.curl}/bin/curl -s \"https://wttr.in/Stralsund?format=%C;%t\"); IFS=';' read -r cond temp <<< \"\$output\"; lc=\$(printf \"%s\" \"\$cond\" | ${pkgs.coreutils}/bin/tr \"[:upper:]\" \"[:lower:]\"); icon=\"\"; case \"\$lc\" in *sun*|*clear*) icon=\"\" ;; *cloud*|*overcast*) icon=\"\" ;; *rain*|*drizzle*|*shower*) icon=\"\" ;; *snow*|*sleet*|*blizzard*|*ice*) icon=\"\" ;; esac; printf \"%s %s\" \"\$icon\" \"\$temp\""
          '';
          interval = 300;
          format = "{}";
          tooltip = false;
        };
        network = {
          interval = 1;
          format-wifi = "  {signalStrength}%";
          tooltip-format = "{essid} {bandwidthTotalBytes} {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "Disconnected ⚠ {ifname}";
          format-alt = " {ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          scroll-step = 2;
          format = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "battery" = {
          interval = 5;
          states = {
            good = 100;
            warning = 50;
            critical = 25;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };
      };
    };
    style = ''
      window#waybar > box {
        opacity: 0.9;
      }
      #workspaces {
        opacity: 0.6;
      }
      .modules-right label {
        margin: 0 5px;
      }
      #tray {
        margin: 0 15px;
      }
      #cpu {
        opacity: 0.6;
      }
      .good {
        color: #${palette.base0B};
      }
      .warning:not(.charging) {
        color: #${palette.base09};
      }
      .critical:not(.charging),
      #network.disconnected {
        color: #${palette.base08};
      }
      #battery.charging,
      #battery.plugged {
        color: #${palette.base0B};
      }
      #battery:not(.charging) {
        font-weight: bold;
      }
      #battery.critical:not(.charging) {
        background-color: red;
        color: #ffffff;
        font-weight: bold;
      }
      #workspaces button.urgent {
        background-color: #${palette.base09};
      }
      #clock.utc {
        margin: 0;
      }
      #clock.local {
        font-weight: bold;
      }
      #idle_inhibitor.activated {
        background-color: #${palette.base08};
        font-weight: bold;
        color: #ffffff;
      }
    '';
  };
}
