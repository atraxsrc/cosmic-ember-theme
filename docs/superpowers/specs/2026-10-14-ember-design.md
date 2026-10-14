# Ember: a paired dark and light COSMIC rice

Date: 2026-10-14. Status: draft for review.

## Goal

Two new rices that are one design: **Ember** (dark, repo `cosmic-ember-theme`,
Dark slot) and **Ember Day** (light, repo `cosmic-emberday-theme`, Light slot).
They share every hue and differ only in lightness and temperature, so COSMIC's
Dark / Light toggle changes the light in the room and nothing else. Each repo
has the full component set the Tokyo Night and Tokyo Day repos have, plus five
wallpapers rendered from the same five subjects, so the pair matches picture
for picture.

Success: both repos install on a Pop!_OS 24.04 COSMIC machine with the
sibling installers, every text role reads at 4.5:1 or better on its window
background, both READMEs follow the sibling layout, and the five wallpapers
per half are produced by a script in the repo from sources in cool-wallpapers.

## The design

One hue family, temperature flipped. Night is a blue-black, day is a warm
stone, and the ember `#E8713A` / `#A4441A` is the only saturated colour on
either. Rules, each of which the Tokyo Day work confirmed:

- Neutrals carry the identity through a slight hue bias; no pure black or white.
- One loud colour, used small: cursor, prompt character, focus ring, tab line,
  window hint. Big shapes (fastfetch logo, box outlines, banner) are ink or fog.
- The terminal is an opaque card: one step lighter than the desktop at night,
  one step darker by day.
- ANSI colours sit in one lightness band so a log reads like a page; hues stay
  apart so red is still red.
- The pair shares hues and changes only lightness.
- Wallpaper base colour equals the window colour within a few units.

## Palette

### Ember (night)

Contrast on the window `#15171C`, then on the pane `#1B1E24`.

| Role | Name | Hex | Window | Pane |
|------|------|-----|--------|------|
| Window background | Night | `#15171C` | | |
| Terminal pane, secondary container | Pane | `#1B1E24` | | |
| Primary container | Soot | `#22262E` | | |
| Raised / selection | Slate | `#2A2F38` | | |
| Text | Fog | `#D6D9E0` | 12.7 | 11.8 |
| Accent, window hint | Ember | `#E8713A` | 5.9 | 5.4 |
| Success | Moss | `#8FB58A` | 7.8 | 7.3 |
| Warning | Amber | `#D9A441` | 8.0 | 7.4 |
| Error | Brick | `#D85A5A` | 4.7 | 4.4 |
| Blue slot | Slate blue | `#7FA3C7` | 6.8 | 6.3 |
| Magenta slot | Heather | `#B08BC4` | 6.3 | 5.8 |
| Cyan slot | Verdigris | `#7FB7B3` | 8.0 | 7.4 |
| Muted | Muted | `#7C8290` | 4.7 | 4.3 |
| Comment | Comment | `#5A6070` | 2.9 | 2.7 |

### Ember Day

Contrast on the window `#E9E6DF`, then on the pane `#DDD9D1`.

| Role | Name | Hex | Window | Pane |
|------|------|-----|--------|------|
| Window background | Stone | `#E9E6DF` | | |
| Primary container | Linen | `#E2DED6` | | |
| Terminal pane, secondary container | Pane | `#DDD9D1` | | |
| Raised / selection | Sand | `#D4CFC6` | | |
| Text | Ink | `#2B2E36` | 10.9 | 9.6 |
| Accent, window hint | Ember | `#A4441A` | 4.9 | 4.4 |
| Success | Moss | `#4C6B45` | 4.8 | 4.3 |
| Warning | Amber | `#8A5E12` | 4.6 | 4.0 |
| Error | Brick | `#9E3A3A` | 5.4 | 4.8 |
| Blue slot | Slate blue | `#2F5C8A` | 5.6 | 4.9 |
| Magenta slot | Heather | `#6E4E8C` | 5.4 | 4.8 |
| Cyan slot | Verdigris | `#2E6E6A` | 4.7 | 4.2 |
| Muted | Muted | `#6B6F78` | 4.0 | 3.6 |
| Comment | Comment | `#8C9099` | 2.6 | 2.3 |

The day accent was darkened from the mockup's `#B84E1E` (4.1:1) to `#A4441A`
so it clears 4.5:1 on the window. Muted and comment are de-emphasis roles in
both halves and sit under 4.5 on purpose, as every sibling does. On the pane,
day warning, cyan, success and accent land between 4.0 and 4.4, the same trade
Tokyo Day and Dossier make and document.

### Neutral ramps (COSMIC `neutral_0` to `neutral_10`)

Night, window to lightest text, linear RGB:
`#15171C #2A2C31 #3F4146 #54565B #696B70 #7E8085 #92949A #A7A9AF #BCBEC4 #D1D3D9 #E6E8EE`
with `neutral_tint #7E8085`.

Day, primary container to ink:
`#E2DED6 #D0CCC6 #BDBBB6 #ABA9A6 #999896 #868686 #747476 #626366 #505156 #3D4046 #2B2E36`
with `neutral_tint #868686`.

### Terminal ANSI

Night: bright is normal blended 12 percent toward white, dim is normal blended
40 percent toward the pane. Black is the raised slate, white is the text;
bright white is the exception at `#E2E4E9` (about 29 percent toward white) so
bold text reads as clearly whiter than fog.

| Slot | Normal | Bright | Dim |
|------|--------|--------|-----|
| black | `#2A2F38` | `#7C8290` | `#242830` |
| red | `#D85A5A` | `#DD6E6E` | `#8C4244` |
| green | `#8FB58A` | `#9CBE98` | `#617961` |
| yellow | `#D9A441` | `#DEAF58` | `#8D6E35` |
| blue | `#7FA3C7` | `#8EAECE` | `#576E86` |
| magenta | `#B08BC4` | `#B999CB` | `#745F84` |
| cyan | `#7FB7B3` | `#8EC0BC` | `#577A7A` |
| white | `#D6D9E0` | `#E2E4E9` | `#8B8E95` |

Foreground `#D6D9E0`, background `#1B1E24`, cursor `#E8713A`, bright
foreground `#E2E4E9`, dim foreground `#7C8290`. Bright black is muted so
`ls` dotfiles and prompts that use it stay readable.

Day: bright is normal darkened 15 percent, dim is normal blended 40 percent
toward the pane. Black is ink, white is muted.

| Slot | Normal | Bright | Dim |
|------|--------|--------|-----|
| black | `#2B2E36` | `#25272E` | `#727274` |
| red | `#9E3A3A` | `#863131` | `#B77A76` |
| green | `#4C6B45` | `#415B3B` | `#86977D` |
| yellow | `#8A5E12` | `#75500F` | `#AB8F5E` |
| blue | `#2F5C8A` | `#284E75` | `#758EA6` |
| magenta | `#6E4E8C` | `#5E4277` | `#9A86A8` |
| cyan | `#2E6E6A` | `#275E5A` | `#749993` |
| white | `#6B6F78` | `#5B5E66` | `#99999C` |

Foreground `#2B2E36`, background `#DDD9D1`, cursor `#A4441A`, bright
foreground `#25272E`, dim foreground `#6B6F78`.

### Syntax roles (Neovim, zsh, Postilla via the terminal scheme)

Same mapping both halves: keywords magenta, strings green, functions blue,
numbers yellow, types cyan, comments comment, operators muted, links cyan,
special ember.

## Repo structure

Both repos are file for file the Tokyo Night / Tokyo Day layout, including
`scripts/contrast.py` (from Tokyo Day) in both, and one new script:
`scripts/wallpaper.sh`, the recolour pipeline. Names: dark repo files
`Ember.*`, scheme `Ember`, palette `Ember`; light repo files `EmberDay.*`,
scheme `Ember Day`, palette `Ember-Day`; lowercase `ember` / `emberday`;
icon packs `Cosmic-Ember-<Variant>` and `Cosmic-EmberDay-<Variant>`; cursors
`Oxygen-Ember-<Variant>` and `Oxygen-EmberDay-<Variant>`; Firefox "Cosmic
Ember" and "Cosmic Ember Day".

Seeding: `cosmic-ember-theme` is copied from `cosmic-tokyonight-theme` (dark
template) and `cosmic-emberday-theme` from `cosmic-tokyoday-theme` (light
template, already carries the contrast script and the opaque-pane terminal).
Fresh git repos, one first commit each, same as the earlier light siblings.

## Component mapping

### COSMIC appearance ron

Night, `palette: Dark((name: "Ember", ...))`: bright_red brick, bright_green
moss, bright_orange ember, gray_1 `#22262E`, gray_2 `#2A2F38`, neutral ramp
above, accent_blue slate blue, accent_indigo heather, accent_purple heather,
accent_pink brick, accent_red brick, accent_orange ember, accent_yellow amber,
accent_green moss, warm greys muted, ext_orange ember, ext_yellow amber,
ext_blue verdigris, ext_purple heather, ext_pink brick, ext_indigo heather.
Top level: `bg_color #15171C`, `primary_container_bg #22262E`,
`secondary_container_bg #1B1E24`, `text_tint #D6D9E0`, `accent #E8713A`,
`success #8FB58A`, `warning #D9A441`, `destructive #D85A5A`,
`window_hint #E8713A`, `neutral_tint #7E8085`.

Day, `palette: Light((name: "Ember-Day", ...))`: the same slot assignment
with the day values, except gray_2 which follows the Tokyo Day convention and
equals the pane `#DDD9D1` (the top-level container keys set the surfaces); `bg_color #E9E6DF`, `primary_container_bg #E2DED6`,
`secondary_container_bg #DDD9D1`, `text_tint #2B2E36`, `accent #A4441A`,
`success #4C6B45`, `warning #8A5E12`, `destructive #9E3A3A`,
`window_hint #A4441A`, `neutral_tint #868686`.

Both rons carry the complete frosted block verbatim from the Tokyo Day spec
(`frosted: Low`, five flags, fourteen alpha_map keys) with the text tint
pinned, because of libcosmic pull 1450; both READMEs carry the "Known COSMIC
bug" paragraph. Spacing, corner radii (2.0), gaps `(0, 7)` and
`active_hint 1` are the shared baseline.

### Terminal, config, btop, fastfetch, zsh, lsd, Neovim, update script

The Tokyo Day component rules apply with the palette swapped, in both halves:

- Terminal scheme has `background` set to the pane; shipped `opacity` 100;
  `syntax_theme_dark "Ember"` in the dark repo, `syntax_theme_light "Ember Day"`
  in the light one; icon theme `Cosmic-Ember-Ember` / `Cosmic-EmberDay-Ember`.
- btop: `main_bg` empty, boxes and title in text colour (night fog, day ink),
  highlights and selection ember, meters moss to ember to brick, cached amber,
  available verdigris, used brick, inactive comment.
- fastfetch: logo in fog (night) or ink (day), keys ember, titles heather, box
  lines text blended 70 percent toward the pane (`#53565C` night, `#A8A6A2`
  day), palette dots text, ember, moss, amber, brick, heather, verdigris.
- zsh: commands ember, directories bold slate blue, symlinks italic verdigris,
  executables bold moss, archives amber, images heather, code moss, documents
  text, broken links brick; autosuggest comment blended 30 percent toward the
  pane (`#474C59` night, `#A4A6AA` day); strings moss, comments comment,
  options and separators muted, paths text underlined, unknown tokens brick.
- lsd 256 indices (nearest cube colour, adjusted where two roles collide or
  the nearest is a grey). Night: ember 173, moss 108, amber 179, brick 167,
  slate blue 110, heather 140, verdigris 109, muted 102, comment 241, text
  253. Day: ember 130, moss 65, amber 94, brick 131, slate blue 24, heather 60,
  verdigris 23, muted 242, comment 246, ink 236.
- Neovim: bg is the pane, bg1 the window colour, bg2 the pane shifted 8
  percent toward white (night `#2D3036`) or black (day `#CBC8C0`); roles per
  the syntax section; terminal colours 0 to 15 from the ANSI tables;
  `background` dark / light accordingly.
- Update script: headers text colour, info ember, success moss, warnings amber,
  skipped muted, errors brick, comments comment; banner gradient text colour
  to ember across the 46 columns, logo rule text / ember.

### Firefox

Night from Noir's dark manifest and stylesheets (the dark baseline port),
day from Tokyo Day's. Night roles: frame `#15171C`, toolbar and popups
`#22262E`, field `#1A1C22`, text fog, inactive tab text muted, icons moss,
loud roles ember, button hover `#2A2F38`, menu hover `#3A2F2F`, pressed
`#4A3530`, accent hover `#EB8252`, popup border `#3F4146` (manifest and
stylesheet borders alike), highlight text `#15171C`. Day roles: frame `#E9E6DF`, toolbar and popups `#E2DED6`,
field `#E9E6E0`, text ink, inactive tab text `#505156` (neutral_8, so it
clears 4.5:1; muted would not), icons moss, loud roles ember, button hover
`#D4CFC6`, menu hover `#DBCCBF`, pressed `#D6BFB0`, accent hover `#8B3A16`,
popup border `#999896` (manifest and stylesheets alike), highlight text
`#E9E6DF`. New gecko ids, icons
generated as rings (ember and moss on the window colour). AMO listings are
the user's step; slugs `cosmic-ember-theme` and `cosmic-emberday-theme`,
checked free before the README links them.

### Cursors and icons

Four variants per half, same names both sides: **Ember** (default), **Moss**,
**Slate** (the blue slot) and **Dark** (night: front `#2A2F38`, back
`#7C8290`, symbol ember) / **Ink** (day: front `#2B2E36`, back `#505156`,
symbol ember). Front, back and symbol are icon-pack keys; cursors take the
front colour only, via Dark Gold's `recolour.py` from a Tokyo Night Blue base,
previews on the window colour, so Dark / Ink cursors are body-colour variants
with low contrast on the window, stated as such in the cursors README. Icons: `Ember` and `EmberDay` entries in
cosmic-icon-themes `palettes.py` (bg and text per half), test expectations,
README rows, previews, then a release carrying all 32 packs.

### Wallpapers

Five subjects, the same five in both halves, from cool-wallpapers:
`tokyonight/astronaut-flying-5120x3200.png`,
`tokyonight/hannya-samurai-2664x1700.png`,
`tokyonight/geisha-3360x2100.png`, `tokyonight/neon-city-5120x2880.png`,
`omarchy/the-greek/the-greek-bg1-3840x2160.jpg` (the eagle, MIT, HANCORE).
Output `backgrounds/ember-<subject>.png` and `backgrounds/emberday-<subject>.png`
at 3840x2160, cover-cropped, centred.

`scripts/wallpaper.sh night|day SOURCE OUT` in each repo renders one file
with ImageMagick 6: convert to grey, invert when the source's mean luminance
is above 0.5 for night (ink-on-paper sources) or below 0.5 for day (dark
sources), then map through a 256-row colour lookup built from stacked
gradients, with a flat band at the window end so source backgrounds that are
not pure black or white (the cool-wallpapers sources sit at 5 to 12 percent
grey, the eagle's paper at 83) still land exactly on the window colour. Alpha
is dropped.

Night, ember on highlights only:
`#15171C` flat (48 rows), to `#2A2F38` (42), to `#7C8290` (70), to `#E8713A` (60), to `#F1D9C8` (36).

Day:
`#2B2E36` to `#6B6F78` (100), to `#A4441A` (50), to `#D4CFC6` (40), to `#E9E6DF` (15), `#E9E6DF` flat (51).

The script is the record of how every wallpaper was made, so a new subject is
one command. `assets/wallpaper.png` and `assets/screenshot.png` are taken by
the user on the finished desktop; the astronaut is the README wallpaper for
both halves.

### Docs

Each README follows the Tokyo Day README section for section, with the
palette table in the Noir / Dossier layout (Role, swatch plus name, Hex),
generated by `scripts/contrast.py`, and a pair table Ember / Ember Day. Credits
name the subjects' sources (cool-wallpapers, HANCORE for the eagle), the
Tokyo Night and Tokyo Day repos as templates and Dark Gold as the baseline.
`docs/showcase.md` per half.

## Out of scope

AMO publishing; the cosmic-icon-themes GitHub release; screenshots and
`assets/wallpaper.png`; any wallpaper beyond the five.

## Verification

Per repo: `scripts/contrast.py` exits 0; `bash -n` on every script; JSON
parses for fastfetch and the manifest; headless Neovim loads the colorscheme;
the ron contains text_tint, neutral_tint, `frosted:`, five `frosted_*` flags
and fourteen alpha_map keys; the terminal scheme contains `background`; a
case-insensitive grep for `tokyonight`, `tokyoday`, `tokyo` returns only
credit lines; the layout diff against the template repo is empty apart from
`scripts/wallpaper.sh` (and `scripts/contrast.py` in the dark repo, which
Tokyo Night lacks); five wallpapers exist at 3840x2160 and all four corner
pixels equal the window colour; cosmic-icon-themes tests pass.
