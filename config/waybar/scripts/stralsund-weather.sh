#!/usr/bin/env bash
set -euo pipefail

output="$(curl -fsS --max-time 5 'https://wttr.in/Stralsund?format=%C;%t;%f' 2>/dev/null || true)"
[ -n "$output" ] || exit 0

IFS=';' read -r cond temp feels <<< "$output"
lc="$(printf '%s' "$cond" | tr '[:upper:]' '[:lower:]')"

icon=''
case "$lc" in
  *sun*|*clear*) icon='' ;;
  *cloud*|*overcast*) icon='' ;;
  *rain*|*drizzle*|*shower*) icon='' ;;
  *snow*|*sleet*|*blizzard*|*ice*) icon='' ;;
esac

python - "$icon" "$temp" "$cond" "$feels" <<'PY'
import json
import sys
icon, temp, cond, feels = sys.argv[1:]
print(json.dumps({
    "text": f"{icon} {temp}",
    "tooltip": f"Stralsund: {cond} (feels {feels})",
}))
PY
