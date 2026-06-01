local wezterm = require("wezterm")
local fonts = require('config.font')

local light_theme = "Google Light (base16)"
local dark_theme = "OneDark (base16)"
local appearance = wezterm.gui.get_appearance()

local current_theme = dark_theme
local act_tab_bg = "#000000"
local inact_tab_bg = "#333333"

if appearance:find("Dark") then
  current_theme = dark_theme
else
  current_theme = light_theme
end

return {
  term = "xterm-256color",
  front_end = "WebGpu",
  webgpu_power_preference = "HighPerformance",
  color_scheme = current_theme,

  -- background
  window_background_opacity = 1.0,
  macos_window_background_blur = 30,
  -- win32_system_backdrop = "Acrylic",
  -- window_background_gradient = {
  --   colors = { "#1D261B", "#261A25" },
  --   -- Specifices a Linear gradient starting in the top left corner.
  --   orientation = { Linear = { angle = -45.0 } },
  -- },
  -- background = {
  --   {
  --     source = { File = wezterm.config_dir .. "/backdrops/space.jpg" },
  --   },
  --   {
  --     source = { Color = "#1A1B26" },
  --     height = "100%",
  --     width = "100%",
  --     opacity = 0.95,
  --   },
  -- },

  -- scrollbar
  enable_scroll_bar = true,
  -- min_scroll_bar_height = "3cell",
  -- colors = {
  --   scrollbar_thumb = "#575880",
  -- },

  -- tab bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,
  -- tab_max_width = 25,
  show_tab_index_in_tab_bar = true,
  switch_to_last_active_tab_when_closing_tab = true,

  -- cursor
  -- default_cursor_style = "BlinkingBlock",
  -- cursor_blink_ease_in = "Constant",
  -- cursor_blink_ease_out = "Constant",
  -- cursor_blink_rate = 700,

  -- window
  adjust_window_size_when_changing_font_size = false,
  window_decorations = "RESIZE",
  integrated_title_button_style = "Windows",
  integrated_title_button_color = "auto",
  integrated_title_button_alignment = "Right",
  -- initial_cols = 120,
  -- initial_rows = 24,
  window_padding = {
    left = 5,
    right = 10,
    top = 12,
    bottom = 7,
  },
  window_close_confirmation = "AlwaysPrompt",
  window_frame = {
    -- active_titlebar_bg = act_tab_bg,
    -- inactive_titlebar_bg = inact_tab_bg,
    font = fonts.font,
    font_size = fonts.font_size,
  },
  inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
}
