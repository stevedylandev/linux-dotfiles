# st

Config for [st](https://st.suckless.org/), the suckless simple terminal.
Built from the **0.9.3** tarball; st is configured at compile time, so
`config.h` here is the source of truth — the build tree lives at `~/st-0.9.3`
and installs to `/usr/local/bin/st`.

## Patches applied

Downloaded from the URLs below and applied with `git apply`, in this order:

| Patch | Source |
| --- | --- |
| wide glyph support | https://st.suckless.org/patches/glyph_wide_support/st-glyph-wide-support-20220411-ef05519.diff |
| kitty graphics protocol | https://st.suckless.org/patches/kitty-graphics-protocol/st-kitty-graphics-20251230-0.9.3.diff |
| clipboard | https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff |
| anysize | https://st.suckless.org/patches/anysize/ |

The colorscheme is hand-edited in `config.h` rather than patched — the
`st-color_schemes` / `st-colorschemes` diffs were tried and discarded.

## Customizations

- Font: `BerkeleyMono Nerd Font:size=13`, `borderpx = 2`
- "Darkmatter" colorscheme (bg `#121113`, accents `#e78a53` / `#fbcb97`,
  cursor `#ffffff`) — **keep in sync with `../wezterm/dot-wezterm.lua`**
- Beam cursor, thickness 2; bell silenced; `worddelimiters = L" "`
- anysize centering (`halign`/`valign` = 50)
- Shortcuts: `Ctrl+Shift+C`/`V` copy/paste, `Super+V` paste,
  `Ctrl+Shift+F1/F6/F7/F8` graphics debug/dump/unload/toggle,
  `Ctrl+Shift+Right-click` previews an image with `feh`

## Rebuilding

```sh
cd ~/st-0.9.3
cp ~/dotfiles/st/config.h config.h   # config.def.h is kept identical
doas make clean install
```
