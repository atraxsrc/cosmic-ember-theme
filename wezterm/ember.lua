-- Ember for WezTerm, part of cosmic-ember-theme (MIT).
-- Colours follow the COSMIC Terminal scheme (cosmic-term/).
--
-- Install: ./wezterm/install.sh puts this in ~/.config/wezterm/, then in
-- ~/.config/wezterm/wezterm.lua:
--   config.colors = require("ember")
-- To follow COSMIC's Dark / Light toggle with the Ember Day half installed too:
--   local dark = (wezterm.gui and wezterm.gui.get_appearance() or "Dark"):find("Dark")
--   config.colors = require(dark and "ember" or "emberday")

return {
  foreground = "#D6D9E0",
  background = "#1B1E24",

  cursor_bg = "#E8713A",
  cursor_fg = "#1B1E24",
  cursor_border = "#E8713A",
  compose_cursor = "#D9A441",

  selection_bg = "#3E4147",
  selection_fg = "none",

  scrollbar_thumb = "#7C8290",
  split = "#7C8290",

  -- black, red, green, yellow, blue, magenta, cyan, white
  ansi = { "#2A2F38", "#D85A5A", "#8FB58A", "#D9A441", "#7FA3C7", "#B08BC4", "#7FB7B3", "#D6D9E0" },
  brights = { "#7C8290", "#DD6E6E", "#9CBE98", "#DEAF58", "#8EAECE", "#B999CB", "#8EC0BC", "#E2E4E9" },

  copy_mode_active_highlight_bg = { Color = "#E8713A" },
  copy_mode_active_highlight_fg = { Color = "#15171C" },
  copy_mode_inactive_highlight_bg = { Color = "#D9A441" },
  copy_mode_inactive_highlight_fg = { Color = "#1B1E24" },

  quick_select_label_bg = { Color = "#D9A441" },
  quick_select_label_fg = { Color = "#1B1E24" },
  quick_select_match_bg = { Color = "#D9A441" },
  quick_select_match_fg = { Color = "#1B1E24" },

  tab_bar = {
    background = "#1B1E24",
    active_tab = { bg_color = "#E8713A", fg_color = "#15171C", intensity = "Bold" },
    inactive_tab = { bg_color = "#22262E", fg_color = "#808693" },
    inactive_tab_hover = { bg_color = "#1B1E24", fg_color = "#D6D9E0" },
    new_tab = { bg_color = "#1B1E24", fg_color = "#808693" },
    new_tab_hover = { bg_color = "#1B1E24", fg_color = "#E8713A" },
  },
}
