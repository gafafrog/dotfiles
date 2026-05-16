#!/usr/bin/env bash
# Insert the current tmux window at target index by bubbling via swap-window.
# Usage: insert-window.sh <target-index>
set -eu

target="${1:?target index required}"
current="$(tmux display-message -p '#I')"

while [ "$current" -gt "$target" ]; do
  prev=$((current - 1))
  tmux swap-window -d -s ":$current" -t ":$prev"
  current=$prev
done

while [ "$current" -lt "$target" ]; do
  next=$((current + 1))
  tmux swap-window -d -s ":$current" -t ":$next"
  current=$next
done
