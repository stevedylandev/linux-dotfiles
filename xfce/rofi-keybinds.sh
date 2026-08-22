#!/bin/sh
# Requires: xfconf-query (xfce4-settings)
# Points the XFCE keyboard shortcuts at the rofi menus in ../rofi/scripts,
# and can put back whatever those keys did before.
#
# This is a script rather than a checked-in xfconf XML file because xfconf
# rewrites its own config atomically, by rename — which would replace a
# symlink from this repo with a regular file the first time anything changed
# a shortcut through the settings GUI.
#
# Usage: rofi-keybinds.sh            apply (idempotent, safe to re-run)
#        rofi-keybinds.sh --remove   restore what these keys did before
#        rofi-keybinds.sh --list     show which keys currently run rofi
#
# xfsettingsd watches xfconf, so changes take effect immediately — no logout.
set -u

CHANNEL=xfce4-keyboard-shortcuts
BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/rofi-keybinds.backup"

# Where the menu scripts live. The repo layout is the default; point
# ROFI_SCRIPTS somewhere else to bind an installed copy instead.
S=${ROFI_SCRIPTS:-$(CDPATH= cd -- "$(dirname -- "$0")/../rofi/scripts" 2>/dev/null && pwd)}
[ -n "${S:-}" ] && [ -d "$S" ] || S="$HOME/.config/rofi/scripts"
[ -d "$S" ] || { echo "rofi-keybinds: no rofi scripts directory found" >&2; exit 1; }

command -v xfconf-query >/dev/null 2>&1 ||
    { echo "rofi-keybinds: xfconf-query not found — is this an XFCE session?" >&2; exit 1; }

# key<TAB>command. Super+Tab, Super+f/h/l and Super+1-4 are missing from this
# list on purpose: xfwm4 grabs those for window and workspace handling, so a
# command bound to them would never fire.
binds() {
    cat <<BINDS
/commands/custom/<Super>d	rofi -show drun
/commands/custom/<Super>space	rofi -show drun
/commands/custom/<Alt>F2	rofi -show run
/commands/custom/<Super>r	rofi -show run
/commands/custom/<Super>w	rofi -show window
/commands/custom/<Shift><Super>f	rofi -show filebrowser
/commands/custom/<Super>v	$S/rofi-clip
/commands/custom/<Shift><Super>e	$S/rofi-emoji
/commands/custom/<Shift><Super>c	$S/rofi-calc
/commands/custom/<Shift><Super>x	$S/rofi-power
/commands/custom/<Shift><Super>n	$S/rofi-wifi
/commands/custom/<Shift><Super>u	$S/rofi-audio
/commands/custom/<Super>s	$S/rofi-screenshot
/commands/custom/Print	$S/rofi-screenshot
/commands/custom/<Super>slash	$S/rofi-websearch
BINDS
}

# Shortcuts for xfce4-screenshooter, which is not installed — these keys do
# nothing at all today, so they are dropped rather than repointed.
DEAD="/commands/custom/<Shift>Print
/commands/custom/<Alt>Print"

get() { xfconf-query -c "$CHANNEL" -p "$1" 2>/dev/null; }
exists() { xfconf-query -c "$CHANNEL" -p "$1" >/dev/null 2>&1; }

# One line per property, the first time it is touched: "prop<TAB>type<TAB>old
# value", with an empty value meaning the property did not exist. Re-running
# apply must not overwrite an entry, or the original would be lost behind a
# rofi command.
record() {
    mkdir -p "$(dirname "$BACKUP")"
    [ -f "$BACKUP" ] &&
        awk -F'\t' -v p="$1" '$1 == p { found = 1 } END { exit !found }' "$BACKUP" &&
        return 0
    printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$BACKUP"
}

put() {
    if exists "$1"; then
        xfconf-query -c "$CHANNEL" -p "$1" -s "$3"
    else
        xfconf-query -c "$CHANNEL" -p "$1" -n -t "$2" -s "$3"
    fi
}

apply() {
    binds | while IFS='	' read -r prop cmd; do
        [ -n "$prop" ] || continue
        old=$(get "$prop")
        [ "$old" = "$cmd" ] && continue

        record "$prop" string "$old"
        put "$prop" string "$cmd" >/dev/null

        # The appfinder keys carry startup-notify. rofi never sends the
        # matching "I am up" message, so the busy cursor would spin for its
        # full timeout on every launch.
        sn="$prop/startup-notify"
        if exists "$sn"; then
            record "$sn" bool "$(get "$sn")"
            xfconf-query -c "$CHANNEL" -p "$sn" -s false
        fi

        printf '  %-40s → %s\n' "${prop#/commands/custom/}" "$cmd"
    done

    printf '%s\n' "$DEAD" | while read -r prop; do
        [ -n "$prop" ] && exists "$prop" || continue
        record "$prop" string "$(get "$prop")"
        xfconf-query -c "$CHANNEL" -p "$prop" -r
        printf '  %-40s → removed (xfce4-screenshooter is not installed)\n' "${prop#/commands/custom/}"
    done
}

remove() {
    [ -f "$BACKUP" ] || { echo "rofi-keybinds: nothing to restore"; exit 0; }
    while IFS='	' read -r prop type value; do
        [ -n "$prop" ] || continue
        if [ -z "$value" ]; then
            xfconf-query -c "$CHANNEL" -p "$prop" -r 2>/dev/null
            printf '  %-40s → unbound\n' "${prop#/commands/custom/}"
        else
            put "$prop" "$type" "$value" >/dev/null
            printf '  %-40s → %s\n' "${prop#/commands/custom/}" "$value"
        fi
    done < "$BACKUP"
    rm -f "$BACKUP"
}

case "${1:-}" in
    "")        echo "Binding rofi menus in $S:"; apply ;;
    --remove)  echo "Restoring shortcuts from $BACKUP:"; remove ;;
    --list)    xfconf-query -c "$CHANNEL" -p /commands/custom -lv | grep -i rofi ;;
    *)         echo "usage: rofi-keybinds.sh [--remove|--list]" >&2; exit 2 ;;
esac
