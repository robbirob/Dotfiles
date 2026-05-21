#!/usr/bin/env bash
set -euo pipefail

# Generic MPRIS media indicator. It intentionally does not require Spotify;
# when no compatible player is running Waybar hides the module.
status="$(playerctl status 2>/dev/null || true)"
track="$(playerctl metadata --format '{{xesam:artist}} - {{xesam:title}}' 2>/dev/null || true)"
track="$(printf '%s' "$track" | tr -s ' ' | sed -e 's/^ *//' -e 's/ *$//')"

[ -n "$track" ] || exit 0

class='playing'
icon=''
if [ "$status" != 'Playing' ]; then
  class='paused'
  icon=''
fi

text="$icon $track"
if [ "${#text}" -gt 42 ]; then
  text="${text:0:39}..."
fi

python - "$text" "$track" "$class" <<'PY'
import json
import sys
text, tooltip, klass = sys.argv[1:]
print(json.dumps({"text": text, "tooltip": tooltip, "class": klass}))
PY
