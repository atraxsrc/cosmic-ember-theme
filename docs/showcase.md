# Ember

> Night, fog and one ember. The dark half of Ember / Ember Day.

Pop!_OS 24.04 on the COSMIC desktop, one palette carried through the whole
machine: desktop, terminal, shell, editor, browser. This note is the rice
describing itself, written in Markdown and rendered by **Postilla**.

## Palette

Every text colour is checked against the window background ![#15171C](https://placehold.co/12x12/15171c/15171c.png) `#15171C`.

| Role | Hex | Contrast on background |
|------|-----|------------------------|
| Text | ![#D6D9E0](https://placehold.co/12x12/d6d9e0/d6d9e0.png) `#D6D9E0` | 12.7:1 |
| Ember, accent | ![#E8713A](https://placehold.co/12x12/e8713a/e8713a.png) `#E8713A` | 5.9:1 |
| Moss, success | ![#8FB58A](https://placehold.co/12x12/8fb58a/8fb58a.png) `#8FB58A` | 7.8:1 |
| Amber, warning | ![#D9A441](https://placehold.co/12x12/d9a441/d9a441.png) `#D9A441` | 8.0:1 |
| Brick, error | ![#D85A5A](https://placehold.co/12x12/d85a5a/d85a5a.png) `#D85A5A` | 4.7:1 |
| Heather, magenta | ![#B08BC4](https://placehold.co/12x12/b08bc4/b08bc4.png) `#B08BC4` | 6.3:1 |
| Verdigris, symlinks | ![#7FB7B3](https://placehold.co/12x12/7fb7b3/7fb7b3.png) `#7FB7B3` | 8.0:1 |

Containers sit one step away from the background at ![#22262E](https://placehold.co/12x12/22262e/22262e.png) `#22262E`, which is
what frosted glass blurs into. The terminal is the exception: an opaque pane
at ![#1B1E24](https://placehold.co/12x12/1b1e24/1b1e24.png) `#1B1E24`, one step lighter than the desktop.

## Where the colours go

```mermaid
flowchart LR
    P[Ember palette] --> D[COSMIC desktop<br/>Ember.ron, Dark slot]
    P --> T[COSMIC Terminal<br/>Ember]
    P --> S[zsh layer<br/>LS_COLORS, highlighting, starship]
    P --> E[Postilla<br/>syntax theme from the terminal scheme]
    T --> B[btop, bat, lsd, fastfetch]
    D --> F[Firefox<br/>Cosmic Ember + userChrome]
```

## Setup, in order

- [x] Import `cosmic/Ember.ron` into Appearance, **Dark** slot
- [x] Import `cosmic-term/Ember-term.ron`, pick **Ember** for the profile
- [x] `./icons/install.sh` for the **Cosmic-Ember** icons, `./cosmic/install.sh` for fonts and the terminal look
- [x] `./zsh/install.sh`, `./lsd/install.sh`, `./fastfetch/install.sh`
- [x] Cursor: Oxygen-Ember-Ember
- [x] Wallpaper: `backgrounds/ember-anime.png`
- [x] Screenshot for the README

## The baseline every rice shares

```ron
corner_radii: (
    radius_xs: (2.0, 2.0, 2.0, 2.0),   // squared corners
    radius_xl: (2.0, 2.0, 2.0, 2.0),
),
frosted: Low,
frosted_windows: true,
frosted_panel: true,
frosted_applets: true,
frosted_maximized_apps: false,
gaps: (0, 4),
active_hint: 1,
```

Contrast is the WCAG ratio[^1], where $L$ is relative luminance:

```typst
$ (L_1 + 0.05) / (L_2 + 0.05) >= 4.5 $
```

---

*Rendered in Postilla, a Markdown notes app for COSMIC. The window is painted
with this rice's terminal scheme, imported as a syntax theme.*

[^1]: Web Content Accessibility Guidelines, success criterion 1.4.3. Normal text wants 4.5:1, large text 3:1.
