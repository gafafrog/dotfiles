#!/usr/bin/env bash
# Push a tmux pane to an "aside" parking window.
#
# Rule: the rightmost aside* window is the active staging window.
# - From a non-aside window: pane goes to the rightmost aside, or a new
#   `aside` window is created (after the current window) if none exists.
# - From an aside that isn't the rightmost: pane goes to the rightmost aside.
# - From the rightmost aside: a fresh `aside-N` is created immediately to the
#   right, where N is one more than the current window's suffix (or 2 if the
#   current window is `aside`). Renamed/freed lower numbers are NOT reused.
#
# An "aside* window" means a window whose name is exactly `aside` or matches
# `aside-<positive integer>`. Renaming a window to anything else removes it
# from this rotation.
#
# Usage: push-to-aside.sh <pane-id> <current-window-name>
set -eu

pane="${1:?pane id required}"
current_name="${2:?current window name required}"
current_index="$(tmux display-message -p -t "$pane" '#I')"

is_aside_name() {
  case "$1" in
    aside) return 0 ;;
    aside-*)
      suf="${1#aside-}"
      case "$suf" in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
      esac
      ;;
    *) return 1 ;;
  esac
}

# Walk windows by index. Track the rightmost aside* window, the highest index
# overall (the absolute right edge to anchor new windows against), and the
# highest aside-N suffix seen so far (for picking the next number).
rightmost_aside_index=""
rightmost_aside_name=""
last_index=""
max_aside_n=1
while IFS=' ' read -r idx name; do
  last_index="$idx"
  if is_aside_name "$name"; then
    rightmost_aside_index="$idx"
    rightmost_aside_name="$name"
    case "$name" in
      aside-*)
        n="${name#aside-}"
        if [ "$n" -gt "$max_aside_n" ]; then max_aside_n="$n"; fi
        ;;
    esac
  fi
done < <(tmux list-windows -F '#{window_index} #{window_name}' | sort -k1,1 -n)

create_new_aside() {
  next_n=$((max_aside_n + 1))
  tmux break-pane -a -t ":$last_index" -s "$pane" -d -n "aside-$next_n"
}

if ! is_aside_name "$current_name"; then
  if [ -z "$rightmost_aside_name" ]; then
    tmux break-pane -a -t ":$last_index" -s "$pane" -d -n aside
  else
    tmux join-pane -h -d -s "$pane" -t ":$rightmost_aside_name"
  fi
elif [ "$current_index" != "$rightmost_aside_index" ]; then
  tmux join-pane -h -d -s "$pane" -t ":$rightmost_aside_name"
else
  create_new_aside
fi
