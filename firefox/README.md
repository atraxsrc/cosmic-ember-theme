# Firefox - Ember

Firefox chrome matching the COSMIC Ember rice. Ported from the DarkGold
baseline (theme recipe and stylesheets), recoloured for blue-black and ember.
The dark half of [Ember Day](https://github.com/atraxsrc/cosmic-emberday-theme).

## Palette

Stylesheets:

| Hex       | Role                      |
|-----------|---------------------------|
| `#15171C` | Frame, page chrome, text on ember |
| `#22262E` | Panels, menus             |
| `#3A2F2F` | Menu hover row (ember tinted into the panel) |
| `#4A3530` | Menu pressed row          |
| `#3F4146` | Separators, menu border   |
| `#E8713A` | Accent, URL bar border, hover rail |
| `#EB8252` | New tab accent hover and active |
| `#8FB58A` | New tab accent, active    |
| `#7FB7B3` | Links                     |
| `#D6D9E0` | Menu text (fog)           |
| `#E2E4E9` | Hover text                |

## Structure

```
firefox/
├── theme/            WebExtension theme source (Cosmic Ember)
│   ├── manifest.json     DarkGold's 24 colour keys + URL bar ring and selection
│   └── icons/            32 / 48 / 64 / 96 / 128, ember and moss rings on the window colour
├── chrome/
│   ├── userChrome.css    browser UI: rounded corners, ember menu hover
│   └── userContent.css   new tab page: ember accents, blank shortcut tiles
└── install.sh            copies chrome/ into the default profile
```

Two layers, use one or both:

1. **Theme (colours):** [Cosmic Ember](https://addons.mozilla.org/en-US/firefox/addon/cosmic-ember-theme/) colours the toolbar, tabs, URL bar,
   menus, sidebar and new tab page. This is the main look.
2. **Stylesheets (optional):** `chrome/` adds rounded corners, ember menu
   hover, ember accents and a blank new-tab grid on top of the theme. They
   also work with Firefox's built-in Dark theme.

## Theme

The same colour keys and roles as the other rices' Firefox themes: icons take
the calm accent, moss, and everything "hot" (tab line, pressed button, menu
and sidebar selection, loading) takes the one ember. One extra key, `toolbar_field_border_focus`, pins the focused
URL bar ring to ember so it does not fall back to the desktop accent when
`widget.non-native-theme.use-theme-accent` is on (the Firefox default on
Linux). Two more, `toolbar_field_highlight` and `toolbar_field_highlight_text`,
colour selected text in the URL bar the same way. Every
text colour clears WCAG AA (4.5:1) on its background; icons and the tab
line clear 3:1.

| Hex       | Where in the theme                          |
|-----------|---------------------------------------------|
| `#15171C` | Frame, new tab, text on ember selections   |
| `#22262E` | Toolbar, menus                              |
| `#1A1C22` | URL bar field                               |
| `#2A2F38` | Button hover, sidebar border                |
| `#3F4146` | Menu border                                 |
| `#D6D9E0` | Body text                                   |
| `#7C8290` | Inactive tab text                           |
| `#8FB58A` | Icons                                       |
| `#E8713A` | Focused URL bar ring and text selection, tab line, pressed button, menu and sidebar selection, loading, attention |

Build the package:

```bash
cd theme && zip -r -X ../cosmic-ember.zip . -x '.*'
```

Try it without installing: `about:debugging#/runtime/this-firefox` → **Load
Temporary Add-on** → pick `theme/manifest.json`. It is gone on restart.

## Stylesheets

```bash
./install.sh
```

Copies `chrome/` into your `*.default-release` profile, backs up anything it
replaces, and adds two prefs to `user.js`: one so Firefox reads the
stylesheets, one so the accent (URL bar ring, buttons) comes from the theme
and not the desktop. Then **fully restart**
Firefox - `userChrome.css` is parsed only at startup.

To install into another profile (a test profile, say), pass its folder:

```bash
./install.sh ~/.mozilla/firefox/<profile>
```

Every rice's `install.sh` takes the same argument, so switching a test
profile between rices is one command plus a restart.

Manual equivalent:

1. `about:config` → `toolkit.legacyUserProfileCustomizations.stylesheets` = `true`
2. `about:support` → Profile Directory → Open Directory
3. Copy `chrome/` in
4. Restart

To undo: delete the two files from the profile's `chrome/` folder and restart.

## Notes

- **Never set `--panel-*` or `--arrowpanel-*` on `:root`.** Those variables leak
  into the toolbar and blank the URL bar. They stay on the popup elements.
- **Context menus do not get an extra element border.** A second stroke made
  the right-click panel look detached. Hover is an ember-tinted `#3A2F2F`
  row with a 3px ember rail on the left, not a full ring.
- **Native menu styling is switched off** (`appearance: none`) on menus and
  menu rows. Without it the COSMIC/GTK hover paints over the colours above.
- **`[_moz-menuactive="true"]` is required.** Firefox marks the active
  context-menu row with that attribute, not only `:hover`.
- **`userContent.css` is colours plus one hide rule.** It sets accent / focus /
  link colours and hides shortcut artwork (`opacity: 0`) so the new-tab tiles
  stay blank. No size or position rules on the tiles.
- Built against **Firefox 154**.

## License

MIT, same as the rest of the repo.
