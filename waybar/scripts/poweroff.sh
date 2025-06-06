#!/bin/bash
case $(
  wofi -d -L 6 -l 3 -W 100 -x -100 -y 10 \
    -D dynamic_lines=true <<EOF | sed 's/^ *//'
    Shutdown
    Reboot
    Log off
    Lock
    Cancel
EOF
) in
"Shutdown")
  systemctl poweroff
  ;;
"Reboot")
  systemctl reboot
  ;;
"Lock")
  swaylock --clock --indicator
  ;;
"Log off")
  swaymsg exit
  ;;
esac
