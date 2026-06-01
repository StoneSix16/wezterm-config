-- Import the wezterm module
local wezterm = require 'wezterm'
local launch = require 'config.launch'
local hotkeys = require 'config.hotkeys'
local font = require 'config.font'
local appearance = require 'config.appearance'
-- local appearance = require 'config.appearance'
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()
local wezterm = require("wezterm")

local function inject(target, source)
  for k, v in pairs(source) do
    if target[k] ~= nil then
      wezterm.log_warn(
        'Duplicate config option detected: ',
        { old = target[k], new = source[k] }
      )
      goto continue
    end
    target[k] = v
    ::continue::
  end
  return target
end

inject(config, launch)
inject(config, hotkeys)
inject(config, font)
inject(config, appearance)

wezterm.on('update-status', function(window, pane)
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local color_scheme = window:effective_config().resolved_palette
  local bg = color_scheme.background
  local fg = color_scheme.foreground


  local title = pane:get_title()
  local domain_name = pane:get_domain_name()
  local text = ""
  
  -- 如果检测到当前是 SSH 进程，换个更醒目的图标或颜色
  if domain_name and domain_name ~= "local" then
    text = " ssh: " .. domain_name .. " "
  else
    text = " " .. title .. " "
  end

  window:set_right_status(wezterm.format({
    -- First, we draw the arrow...
    -- { Background = { Color = 'none' } },
    -- { Foreground = { Color = bg } },
    -- { Text = SOLID_LEFT_ARROW },
    -- Then we draw our text
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = text },
  }))
end)

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config