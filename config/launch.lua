local wezterm = require 'wezterm'
local ssh_config = require 'config.ssh'

local platform = {
  is_win = string.find(wezterm.target_triple, "windows") ~= nil,
  is_linux = string.find(wezterm.target_triple, "linux") ~= nil,
  is_mac = string.find(wezterm.target_triple, "apple") ~= nil,
}

local options = {
  default_prog = {},
  launch_menu = {},
  ssh_domains = {},
}

if platform.is_win then
  options.default_prog = { "C:/Program Files/Git/bin/bash.exe", "--login", "-i" }
  options.launch_menu = {
    {
      label = "GitBash",
      domain = { DomainName = "local" },
      args = { "C:/Program Files/Git/bin/bash.exe", "--login", "-i" },
      cwd = "C:/Users/zh",
    },
    { label = "PowerShell", 
      domain = { DomainName = "local" },
      args = { "powershell" } },
    { label = "Cmd", args = { "cmd" } },
  }
  -- table.insert(options.ssh_domains, {
  --     multiplexing = "None",
  --     name = host,
  --     remote_address = host,
  --   })
elseif platform.is_mac then
  options.default_prog = { "/opt/homebrew/bin/fish", "--login" }
  options.launch_menu = {
    { label = "Bash", args = { "bash", "--login" } },
    { label = "Zsh", args = { "zsh", "--login" } },
  }
elseif platform.is_linux then
  options.default_prog = { "bash", "--login" }
  options.launch_menu = {
    { label = "Bash", args = { "bash", "--login" } },
    { label = "Fish", args = { "/opt/homebrew/bin/fish", "--login" } },
    { label = "Nushell", args = { "/opt/homebrew/bin/nu", "--login" } },
    { label = "Zsh", args = { "zsh", "--login" } },
  }
end

local ssh_options = ssh_config.get_hosts()
if #ssh_options > 0 then
  -- 可以在菜单里加一个分割线/标识（可选）
  -- 遍历读取到的 ssh host，组装成 wezterm 的 launch 选项
  for _, host in ipairs(ssh_options) do
    table.insert(options.ssh_domains, {
      multiplexing = "None",
      name = host,
      remote_address = host,
    })
    table.insert(options.launch_menu, {
      label = "SSH: " .. host,
      domain = {DomainName = host},
      -- args = { "ssh", host },
    })
  end
end


return options