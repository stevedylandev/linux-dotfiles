#!/bin/sh
# Start the polybar bars defined in ./config.ini (installed at
# ~/.config/polybar/config.ini), replacing any bars already running.
#
# The layout is two islands -- "left" and "right" -- as separate bar windows
# with a real gap between them, so add any new bar to BARS below.
#
# Meant to be run as the XFCE session client that used to be xfce4-panel —
# see ../xfce/polybar-panel.sh, which does that swap.
set -u

# Ask a running polybar to quit over IPC, falling back to a signal.
polybar-msg cmd quit >/dev/null 2>&1 || pkill -u "$(id -u)" -x polybar

# Wait for it to actually let go of the bar window before claiming it.
i=0
while pgrep -u "$(id -u)" -x polybar >/dev/null 2>&1 && [ "$i" -lt 20 ]; do
    sleep 0.2
    i=$((i + 1))
done

BARS="left right"

for bar in $BARS; do
    polybar "$bar" &
done

# Stay alive as the session client for as long as the bars are up. polybar
# re-execs in place on `polybar-msg cmd restart`, so these PIDs survive it.
wait
