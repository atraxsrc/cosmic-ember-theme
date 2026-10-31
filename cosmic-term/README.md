# COSMIC Terminal schemes

Colour schemes for COSMIC Terminal. The desktop `.ron` in `cosmic/` does not
colour ANSI text, so the terminal needs its own import.

1. COSMIC Terminal → **View → Color schemes…** (not Settings → Appearance)
2. **Dark** tab → **Import** → a `.ron` from this folder
3. View → Settings → Appearance → Color scheme (dark) → the scheme name

If a profile is set as default, set the scheme on that profile too or the
dropdown will look like it did nothing. `cosmic/install.sh` selects **Ember**,
so import that one at least.

Every scheme here keeps the 16 ANSI colours of Ember. Only the plain text
colour and the dim text change, so bat, lsd, starship, nala and btop look the
same whichever one you pick. The cursor stays ember ![#E8713A](https://placehold.co/12x12/e8713a/e8713a.png) `#E8713A`.

The ANSI slots follow the rice: `red` is brick
![#D85A5A](https://placehold.co/12x12/d85a5a/d85a5a.png) `#D85A5A`; `green` is moss
![#8FB58A](https://placehold.co/12x12/8fb58a/8fb58a.png) `#8FB58A`; `yellow` is
amber ![#D9A441](https://placehold.co/12x12/d9a441/d9a441.png) `#D9A441`; `blue` is
slate blue, the directory colour
![#7FA3C7](https://placehold.co/12x12/7fa3c7/7fa3c7.png) `#7FA3C7`; `magenta` is
heather ![#B08BC4](https://placehold.co/12x12/b08bc4/b08bc4.png) `#B08BC4`; `cyan`
is verdigris, the symlink colour
![#7FB7B3](https://placehold.co/12x12/7fb7b3/7fb7b3.png) `#7FB7B3`; `white` is fog,
the plain text colour ![#D6D9E0](https://placehold.co/12x12/d6d9e0/d6d9e0.png)
`#D6D9E0`. Directories are not affected: `LS_COLORS` in `zsh/ember.zsh` colours them
in truecolor.

## Which one

Fog ![#D6D9E0](https://placehold.co/12x12/d6d9e0/d6d9e0.png) `#D6D9E0` is the default. The others move through Ember's own greys
and tints: calmer above it, brighter below it, for whoever finds the default
glares at night or reads too dim by day.

| Scheme | Plain text | Contrast | Also used for |
|--------|------------|----------|---------------|
| Ember Muted | ![#7C8290](https://placehold.co/12x12/7c8290/7c8290.png) `#7C8290` | 4.3:1 | muted text, the dim text colour and the bright `black` slot |
| Ember Slate | ![#7FA3C7](https://placehold.co/12x12/7fa3c7/7fa3c7.png) `#7FA3C7` | 6.3:1 | directories (`LS_COLORS`), the `blue` slot |
| Ember Moss | ![#8FB58A](https://placehold.co/12x12/8fb58a/8fb58a.png) `#8FB58A` | 7.3:1 | strings, success, the `green` slot |
| Ember Ember | ![#E8713A](https://placehold.co/12x12/e8713a/e8713a.png) `#E8713A` | 5.4:1 | the accent and the cursor |
| Ember Ash | ![#A9AEB8](https://placehold.co/12x12/a9aeb8/a9aeb8.png) `#A9AEB8` | 7.5:1 | a neutral a step from plain text |
| **Ember** (default) | ![#D6D9E0](https://placehold.co/12x12/d6d9e0/d6d9e0.png) `#D6D9E0` | 11.8:1 | the plain text colour of the rice |

When plain text shares a colour with an ANSI slot, output in that slot stops
standing out: directories in Ember Slate, for example, look like plain text.
Errors and numbers stand out more against the dimmer schemes than against
fog.

**Bold:** `bright_foreground` (![#E2E4E9](https://placehold.co/12x12/e2e4e9/e2e4e9.png) `#E2E4E9`) only colours bold text when
`use_bright_bold` is on. The baseline config in `cosmic/config/` leaves it off,
so bold text is the plain text colour at weight 800.

Previews are rendered in Fira Mono on the terminal background ![#1B1E24](https://placehold.co/12x12/1b1e24/1b1e24.png) `#1B1E24`, not
taken from the terminal. In COSMIC you get Maple Mono on the opaque pane, so only the font differs.

## Dark

**Ember** · `Ember-term.ron` · fog ![#D6D9E0](https://placehold.co/12x12/d6d9e0/d6d9e0.png) `#D6D9E0`, 11.8:1. The default.

![Ember](../assets/cosmic-term/Ember-term.png)

**Ember Muted** · `Ember-term-muted.ron` · ![#7C8290](https://placehold.co/12x12/7c8290/7c8290.png) `#7C8290`, 4.3:1. Muted text, the dim text colour and the bright `black` slot.

![Ember Muted](../assets/cosmic-term/Ember-term-muted.png)

**Ember Slate** · `Ember-term-slate.ron` · ![#7FA3C7](https://placehold.co/12x12/7fa3c7/7fa3c7.png) `#7FA3C7`, 6.3:1. Directories (`LS_COLORS`), the `blue` slot.

![Ember Slate](../assets/cosmic-term/Ember-term-slate.png)

**Ember Moss** · `Ember-term-moss.ron` · ![#8FB58A](https://placehold.co/12x12/8fb58a/8fb58a.png) `#8FB58A`, 7.3:1. Strings, success, the `green` slot.

![Ember Moss](../assets/cosmic-term/Ember-term-moss.png)

**Ember Ember** · `Ember-term-ember.ron` · ![#E8713A](https://placehold.co/12x12/e8713a/e8713a.png) `#E8713A`, 5.4:1. The accent and the cursor.

![Ember Ember](../assets/cosmic-term/Ember-term-ember.png)

**Ember Ash** · `Ember-term-ash.ron` · ![#A9AEB8](https://placehold.co/12x12/a9aeb8/a9aeb8.png) `#A9AEB8`, 7.5:1. A neutral a step from plain text.

![Ember Ash](../assets/cosmic-term/Ember-term-ash.png)

Contrast is plain text on the terminal background, WCAG 2.
