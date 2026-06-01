local wezterm = require 'wezterm'

local platform = {
  is_win = string.find(wezterm.target_triple, "windows") ~= nil,
  is_linux = string.find(wezterm.target_triple, "linux") ~= nil,
  is_mac = string.find(wezterm.target_triple, "apple") ~= nil,
}
local act = wezterm.action
local mod = {}

if platform.is_mac then
  mod.COMMAND = "CMD"
  mod.OPTION = "OPT"
  mod.COMMAND_REV = "CMD|SHIFT"
  mod.SUPER = "SUPER"
  mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_win or platform.is_linux then
  mod.COMMAND = "ALT"
  mod.OPTION = "WIN"
  mod.COMMAND_REV = "CTRL|SHIFT"
  mod.SUPER = "ALT" -- to not conflict with Windows key shortcuts
  mod.SUPER_REV = "ALT|CTRL"
end

local keys = {
  -- misc/useful --
  { key = "F1", mods = "NONE", action = "ActivateCopyMode" },
  { key = "F2", mods = "NONE", action = act.ActivateCommandPalette },
  { key = "F3", mods = "NONE", action = act.ShowLauncher },
  { key = "F4", mods = "NONE", action = act.ShowTabNavigator },
  { key = "F11", mods = "NONE", action = act.ToggleFullScreen },
  { key = "F12", mods = "NONE", action = act.ShowDebugOverlay },
  { key = "f", mods = mod.COMMAND, action = act.Search({ CaseInSensitiveString = "" }) },

  -- copy/paste --
  { key = "c", mods = mod.COMMAND, action = act.CopyTo("Clipboard") },
  { key = "v", mods = mod.COMMAND, action = act.PasteFrom("Clipboard") },

  -- tabs --
  -- tabs: spawn+close
  { key = "t", mods = mod.COMMAND, action = act.ShowLauncher },
  -- { key = "t", mods = mod.COMMAND, action = act.SpawnTab("DefaultDomain") },
  { key = "w", mods = mod.COMMAND, action = act.CloseCurrentTab({ confirm = true }) },

  -- tabs: navigation
  { key = "LeftArrow", mods = mod.COMMAND, action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = mod.COMMAND, action = act.ActivateTabRelative(1) },
  --{ key = "[", mods = mod.COMMAND, action = act.ActivateTabRelative(-1) },
  --{ key = "]", mods = mod.COMMAND, action = act.ActivateTabRelative(1) },
  -- { key = "[", mods = mod.OPTION, action = act.MoveTabRelative(-1) },
  -- { key = "]", mods = mod.OPTION, action = act.MoveTabRelative(1) },

  -- window --
  -- spawn windows
  { key = "n", mods = mod.COMMAND, action = act.SpawnWindow },

  -- panes --
  -- panes: split panes
  {
    key = "_",
    mods = mod.COMMAND_REV,
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "|",
    mods = mod.COMMAND_REV,
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "Backspace",
    mods = mod.COMMAND_REV,
    action = act.CloseCurrentPane({ confirm = true }),
  },

  -- panes: zoom+close pane
  { key = "z", mods = mod.COMMAND_REV, action = act.TogglePaneZoomState },
  { key = "w", mods = mod.COMMAND_REV, action = act.CloseCurrentPane({ confirm = false }) },

  -- panes: navigation
  { key = "UpArrow", mods = mod.COMMAND_REV, action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = mod.COMMAND_REV, action = act.ActivatePaneDirection("Down") },
  { key = "LeftArrow", mods = mod.COMMAND_REV, action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = mod.COMMAND_REV, action = act.ActivatePaneDirection("Right") },

  -- panes: resize
  { key = "I", mods = mod.COMMAND_REV, action = act.AdjustPaneSize({ "Up", 1 }) },
  { key = "K", mods = mod.COMMAND_REV, action = act.AdjustPaneSize({ "Down", 1 }) },
  { key = "J", mods = mod.COMMAND_REV, action = act.AdjustPaneSize({ "Left", 1 }) },
  { key = "L", mods = mod.COMMAND_REV, action = act.AdjustPaneSize({ "Right", 1 }) },

  -- fonts --
  -- fonts: resize
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },

  -- key-tables --
  -- resizes fonts
  -- {
  --   key = "f",
  --   mods = "LEADER",
  --   action = act.ActivateKeyTable({
  --     name = "resize_font",
  --     one_shot = false,
  --     timemout_miliseconds = 1000,
  --   }),
  -- },
  -- -- resize panes
  -- {
  --   key = "p",
  --   mods = "LEADER",
  --   action = act.ActivateKeyTable({
  --     name = "resize_pane",
  --     one_shot = false,
  --     timemout_miliseconds = 1000,
  --   }),
  -- },
  -- rename tab bar
  {
    key = "R",
    mods = "CTRL|SHIFT",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
}

local key_tables = {
  resize_font = {
    { key = "k", action = act.IncreaseFontSize },
    { key = "j", action = act.DecreaseFontSize },
    { key = "r", action = act.ResetFontSize },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
  resize_pane = {
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
}

local mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = mod.COMMAND,
    action = act.OpenLinkAtMouseCursor,
  },
  -- Move mouse will only select text and not copy text to clipboard
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Cell"),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.ExtendSelectionToMouseCursor("Cell"),
  },
  {
    event = { Drag = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.ExtendSelectionToMouseCursor("Cell"),
  },
  -- Triple Left click will select a line
  {
    event = { Down = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Line"),
  },
  {
    event = { Up = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Line"),
  },
  -- Double Left click will select a word
  {
    event = { Down = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Word"),
  },
  {
    event = { Up = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Word"),
  },
  -- Turn on the mouse wheel to scroll the screen
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = "NONE",
    action = act.ScrollByCurrentEventWheelDelta,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = "NONE",
    action = act.ScrollByCurrentEventWheelDelta,
  },
}

return {
  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
  -- leader = { key = "Space", mods = "CTRL|SHIFT" },
  keys = keys,
  -- key_tables = key_tables,
  mouse_bindings = mouse_bindings,
}
