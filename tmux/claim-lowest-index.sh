#!/usr/bin/env bash
# Move the current tmux window to the lowest unused index below it, filling
# the lowest gap. No-op (with a status message) if there's no gap below.
set -eu

base="$(tmux show -gv base-index 2>/dev/null || echo 0)"
current="$(tmux display-message -p '#I')"

# Collect existing indices into a sorted, unique list.
indices=$(tmux list-windows -F '#{window_index}' | sort -n -u)

# Walk from base-index upward; the first integer not in the list, and < current,
# is the target.
target=""
i="$base"
for idx in $indices; do
  while [ "$i" -lt "$idx" ]; do
    if [ "$i" -lt "$current" ]; then
      target="$i"
      break 2
    fi
    i=$((i + 1))
  done
  i=$((idx + 1))
done

if [ -z "$target" ]; then
  tmux display-message "no lower gap to claim"
  exit 0
fi

tmux move-window -t ":$target"
