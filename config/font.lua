local wezterm = require("wezterm")

local platform = {
  is_win = string.find(wezterm.target_triple, "windows") ~= nil,
  is_linux = string.find(wezterm.target_triple, "linux") ~= nil,
  is_mac = string.find(wezterm.target_triple, "apple") ~= nil,
}

if platform.is_win then
  font_list = {
    { family = 'Cascadia Mono' , weight = 'DemiLight' },
    { family = 'Microsoft YaHei', weight = 'Regular' }
  }
else -- Mac
  font_list = {
    { family = 'SF Mono', weight = 'Regular'},
    { family = 'PingFang SC', weight = 'Regular'}
  }
end


return {
  font = wezterm.font_with_fallback(font_list),
  font_size = 12,

  --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
  -- freetype_load_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
  -- freetype_render_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}