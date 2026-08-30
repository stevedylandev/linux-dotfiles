#!/bin/sh
# Requires: xfconf-query (xfce4-settings), polybar
# Swaps xfce4-panel out of the XFCE session for polybar, and can put the
# panel back.
#
# xfce4-panel is not an autostart .desktop entry — xfce4-session launches it
# as one of its own session clients, so it has to be replaced there. This is
# a script rather than a checked-in xfconf XML file for the same reason as
# rofi-keybinds.sh: xfconf rewrites its config atomically, by rename, which
# would replace a symlink from this repo with a regular file.
#
# Usage: polybar-panel.sh            apply (idempotent, safe to re-run)
#        polybar-panel.sh --remove   put xfce4-panel back
#        polybar-panel.sh --list     show which session clients run what
#
# Applying also swaps the running session live; no logout needed.
set -u

CHANNEL=xfce4-session
BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/polybar-panel.backup"

# xfwm4's compositor shadows a dock as a rectangle the size of its window,
# ignoring what the window actually paints. polybar's bar spans the screen and
# is transparent everywhere except the islands, so that shadow shows up as a
# band hanging across the empty middle. Turning it off is the only knob for it;
# true is xfwm4's default, which --remove puts back.
dock_shadow() {
    command -v xfconf-query >/dev/null 2>&1 || return 0
    xfconf-query -c xfwm4 -p /general/show_dock_shadow -s "$1" 2>/dev/null ||
        xfconf-query -c xfwm4 -p /general/show_dock_shadow -n -t bool -s "$1"
}

# Where the polybar launcher lives. The repo layout is the default; point
# POLYBAR_LAUNCH somewhere else to use an installed copy instead.
LAUNCH=${POLYBAR_LAUNCH:-$(CDPATH= cd -- "$(dirname -- "$0")/../polybar" 2>/dev/null && pwd)/launch.sh}
[ -f "$LAUNCH" ] || LAUNCH="$HOME/.config/polybar/launch.sh"
[ -x "$LAUNCH" ] || { echo "polybar-panel: no executable launcher at $LAUNCH" >&2; exit 1; }

command -v xfconf-query >/dev/null 2>&1 ||
    { echo "polybar-panel: xfconf-query not found — is this an XFCE session?" >&2; exit 1; }
command -v polybar >/dev/null 2>&1 ||
    { echo "polybar-panel: polybar is not installed" >&2; exit 1; }

# Every session client command in every stored session, as "prop<TAB>[cmd,args]".
clients() {
    xfconf-query -c "$CHANNEL" -lv |
        sed -n 's|^\(/sessions/[^/]*/Client[0-9]*_Command\) *\(\[.*\]\)$|\1\t\2|p'
}

# Set an array property from a "[a,b,c]" literal.
set_array() {
    prop=$1
    args=""
    IFS=,
    for word in $(printf '%s' "$2" | sed 's/^\[//; s/\]$//'); do
        args="$args -t string -s $word"
    done
    unset IFS
    # shellcheck disable=SC2086
    xfconf-query -c "$CHANNEL" -p "$prop" $args --force-array
}

case "${1:-}" in
--list)
    clients | while IFS='	' read -r prop cmd; do
        printf '%-45s %s\n' "$prop" "$cmd"
    done
    ;;
--remove)
    [ -f "$BACKUP" ] || { echo "polybar-panel: nothing to restore ($BACKUP not found)" >&2; exit 1; }
    while IFS='	' read -r prop cmd; do
        [ -n "${prop:-}" ] || continue
        set_array "$prop" "$cmd"
        echo "restored $prop -> $cmd"
    done <"$BACKUP"
    rm -f "$BACKUP"
    dock_shadow true
    polybar-msg cmd quit >/dev/null 2>&1 || pkill -u "$(id -u)" -x polybar
    [ -n "${DISPLAY:-}" ] && command -v xfce4-panel >/dev/null 2>&1 &&
        (xfce4-panel >/dev/null 2>&1 &)
    ;;
"")
    found=0
    clients | while IFS='	' read -r prop cmd; do
        case "$cmd" in
        "[xfce4-panel"*)
            printf '%s\t%s\n' "$prop" "$cmd" >>"$BACKUP"
            set_array "$prop" "[$LAUNCH]"
            echo "$prop -> $LAUNCH"
            ;;
        esac
    done
    clients | grep -q "$LAUNCH" && found=1
    [ "$found" = 1 ] || { echo "polybar-panel: no xfce4-panel session client found" >&2; exit 1; }
    dock_shadow false
    if [ -n "${DISPLAY:-}" ]; then
        pgrep -u "$(id -u)" -x xfce4-panel >/dev/null 2>&1 &&
            xfce4-panel --quit >/dev/null 2>&1
        "$LAUNCH" >/dev/null 2>&1 &
        echo "polybar started; xfce4-panel stopped"
    fi
    ;;
*)
    echo "usage: polybar-panel.sh [--remove|--list]" >&2
    exit 1
    ;;
esac
