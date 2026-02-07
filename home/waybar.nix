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
          "image#spotify-art"
          "custom/spotify"
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
          "persistent-workspaces" = {
            # Keep workspace 10 visible even when empty.
            "10" = [ ];
          };
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "";
            persistent = "";
            default = "";
          };
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

        "image#spotify-art" = {
          exec = ''
            ${pkgs.bash}/bin/bash -lc '
              set -eu

              art_url="$(${pkgs.playerctl}/bin/playerctl -p spotify metadata mpris:artUrl 2>/dev/null || true)"
              track="$(${pkgs.playerctl}/bin/playerctl -p spotify metadata --format "{{xesam:artist}} - {{xesam:title}}" 2>/dev/null || true)"
              track="$(printf "%s" "$track" | ${pkgs.coreutils}/bin/tr -s " " | ${pkgs.gnused}/bin/sed -e "s/^ *//" -e "s/ *$//")"

              if [ -z "$art_url" ]; then
                exit 0
              fi

              if printf "%s" "$art_url" | ${pkgs.gnugrep}/bin/grep -q "^file://"; then
                path="$(printf "%s" "$art_url" | ${pkgs.gnused}/bin/sed -e "s|^file://||")"
                printf "%s\n%s\n" "$path" "$track"
                exit 0
              fi

              cache_root="''${XDG_CACHE_HOME:-''${HOME}/.cache}"
              cache_dir="$cache_root/waybar"
              ${pkgs.coreutils}/bin/mkdir -p "$cache_dir"

              img_path="$cache_dir/spotify-cover.jpg"
              url_path="$cache_dir/spotify-cover.url"

              old_url=""
              if [ -r "$url_path" ]; then
                old_url="$(cat "$url_path" 2>/dev/null || true)"
              fi

              if [ "$art_url" != "$old_url" ] || [ ! -s "$img_path" ]; then
                ${pkgs.curl}/bin/curl -fsSL "$art_url" -o "$img_path.tmp" \
                  && ${pkgs.coreutils}/bin/mv "$img_path.tmp" "$img_path" \
                  && printf "%s" "$art_url" > "$url_path"
              fi

              if [ -s "$img_path" ]; then
                printf "%s\n%s\n" "$img_path" "$track"
              fi
            '
          '';
          size = 24;
          interval = 5;
          tooltip = true;
          on-click = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
          on-scroll-up = "${pkgs.playerctl}/bin/playerctl -p spotify previous";
          on-scroll-down = "${pkgs.playerctl}/bin/playerctl -p spotify next";
        };

        "custom/spotify" = {
          exec = ''
            ${pkgs.bash}/bin/bash -lc '
              set -eu

              window=6
              state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
              state_file="$state_dir/waybar-spotify-scroll"

              status="$(${pkgs.playerctl}/bin/playerctl -p spotify status 2>/dev/null || true)"
              track="$(${pkgs.playerctl}/bin/playerctl -p spotify metadata --format "{{xesam:artist}} - {{xesam:title}}" 2>/dev/null || true)"
              track="$(printf "%s" "$track" | ${pkgs.coreutils}/bin/tr -s " " | ${pkgs.gnused}/bin/sed -e "s/^ *//" -e "s/ *$//")"

              off=0
              last=""
              if [ -r "$state_file" ]; then
                IFS= read -r off < "$state_file" || true
                IFS= read -r last < <(${pkgs.coreutils}/bin/tail -n +2 "$state_file" 2>/dev/null || true) || true
              fi

              # Keep showing the last known track when paused/stopped.
              if [ -z "$track" ]; then
                track="$last"
              fi
              if [ -z "$track" ]; then
                exit 0
              fi

              if [ "$track" != "$last" ]; then
                off=0
              fi

              padded="$track"
              if [ "''${#padded}" -le "$window" ]; then
                while [ "''${#padded}" -lt "$window" ]; do
                  padded="$padded "
                done
              else
                padded="$padded   "
              fi

              len=''${#padded}
              if [ "$len" -le 0 ]; then
                exit 0
              fi
              off=$((off % len))

              part="''${padded:off:window}"
              if [ "''${#part}" -lt "$window" ]; then
                need=$((window - ''${#part}))
                part="$part''${padded:0:need}"
              fi

              class="playing"
              if [ "$status" != "Playing" ]; then
                class="paused"
              fi

              if [ "$status" = "Playing" ]; then
                off=$(((off + 1) % len))
              fi

              {
                printf "%s\n" "$off"
                printf "%s\n" "$track"
              } > "$state_file"

              text="$part"
              ${pkgs.jq}/bin/jq -cn \
                --arg text "$text" \
                --arg tooltip "$track" \
                --arg class "$class" \
                "{text:\$text, tooltip:\$tooltip, class:\$class}"
            '
          '';
          interval = 1;
          hide-empty-text = true;
          return-type = "json";
          format = "{text}";
          tooltip = true;
          on-click = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
          on-scroll-up = "${pkgs.playerctl}/bin/playerctl -p spotify previous";
          on-scroll-down = "${pkgs.playerctl}/bin/playerctl -p spotify next";
        };
        "custom/stralsund-temp" = {
          exec = ''
            ${pkgs.bash}/bin/bash -lc '
              output="$(${pkgs.curl}/bin/curl -s "https://wttr.in/Stralsund?format=%C;%t;%f")"
              IFS=";" read -r cond temp feels <<< "$output"
              lc=$(printf "%s" "$cond" | ${pkgs.coreutils}/bin/tr "[:upper:]" "[:lower:]")
              icon=""
              case "$lc" in
                *sun*|*clear*) icon="" ;;
                *cloud*|*overcast*) icon="" ;;
                *rain*|*drizzle*|*shower*) icon="" ;;
                *snow*|*sleet*|*blizzard*|*ice*) icon="" ;;
              esac
              cond_safe=$(printf "%s" "$cond" | ${pkgs.coreutils}/bin/tr -d "\"")
              feels_safe=$(printf "%s" "$feels" | ${pkgs.coreutils}/bin/tr -d "\"")
              printf "{\"text\":\"%s %s\",\"tooltip\":\"Stralsund: %s (feels %s)\"}" "$icon" "$temp" "$cond_safe" "$feels_safe"
            '
          '';
          interval = 300;
          format = "{}";
          return-type = "json";
          tooltip = true;
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
      #custom-spotify {
        color: #${palette.base0E};
      }
      #custom-spotify.paused {
        opacity: 0.6;
      }

      #image {
        margin: 0 5px;
      }
      #image.empty {
        margin: 0;
      }
    '';
  };
}
